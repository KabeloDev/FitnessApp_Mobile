import 'dart:convert';
import 'dart:io';
import 'package:fitness_app/Dashboard/line.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? username;
  bool isLoading = true;
  String errorMessage = '';
  String? userId;

  int inProgressCount = 0;
  int incompleteCount = 0;
  int completeCount = 0;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
      userId =
          decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

      if (userId != null) {
        await fetchUsername();
        await fetchWorkouts();
      }
    }
  }

  Future<void> fetchUsername() async {
    final String apiUrl = 'https://10.0.2.2:7182/api/Users/GetUserById/$userId';

    final HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          username = data['username'];
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load username.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching username: $e';
      });
    } finally {
      ioClient.close();
    }
  }

  Future<void> fetchWorkouts() async {
    final String apiUrl =
        'https://10.0.2.2:7182/api/Workouts/GetWorkouts/$userId';

    final HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> workouts = json.decode(response.body);

        setState(() {
          inProgressCount =
              workouts.where((w) => w['status'] == 'In Progress').length;
          incompleteCount =
              workouts.where((w) => w['status'] == 'Incomplete').length;
          completeCount =
              workouts.where((w) => w['status'] == 'Complete').length;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load workout data.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching workouts: $e';
        isLoading = false;
      });
    } finally {
      ioClient.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Center(
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : errorMessage.isNotEmpty
                  ? Text(errorMessage)
                  : Stack(
                    children: [
                      Positioned.fill(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.topCenter,
                              colors: [Colors.white, Colors.white.withAlpha(0)],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Image.network(
                            'https://img.freepik.com/premium-photo/background-with-dumbbells-machines-bodybuilding-3d-illustration-copy-space_522591-6.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome, ${username ?? "User"}!',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 50),
                            const Text('Workout Statistics'),
                            const SizedBox(height: 10),
                            workoutBarChart(),
                            const SizedBox(height: 50),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LineChartPage(),
                                  ),
                                );
                              },
                              child: const Text('Exercises Count'),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget workoutBarChart() {
  return SizedBox(
    height: 350,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: [
          inProgressCount.toDouble(),
          incompleteCount.toDouble(),
          completeCount.toDouble(),
        ].reduce((a, b) => a > b ? a : b) + 2, // Ensure bars are visible
        barTouchData: BarTouchData(enabled: true),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
              interval: 1, // Only show every 1st number, no duplication
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text(
                      'In Progress',
                      style: TextStyle(fontSize: 12),
                    );
                  case 1:
                    return const Text(
                      'Incomplete',
                      style: TextStyle(fontSize: 12),
                    );
                  case 2:
                    return const Text(
                      'Complete',
                      style: TextStyle(fontSize: 12),
                    );
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          // Hide top and right titles
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: inProgressCount.toDouble(),
                color: Colors.blue,
                width: 30,
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: incompleteCount.toDouble(),
                color: Colors.red,
                width: 30,
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Colors.red.shade300, Colors.red.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: completeCount.toDouble(),
                color: Colors.green,
                width: 30,
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Colors.green.shade300, Colors.green.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}
