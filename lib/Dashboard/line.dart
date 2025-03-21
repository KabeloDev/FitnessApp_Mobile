import 'dart:convert';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LineChartPage extends StatefulWidget {
  const LineChartPage({super.key});
  @override
  LineChartPageState createState() => LineChartPageState();
}

class LineChartPageState extends State<LineChartPage> {
  bool isLoading = true;
  bool isAuthenticated = false;
  List<FlSpot> chartData = []; // This will store the number of exercises per workout
  List<Map<String, dynamic>> workouts = []; // Change to dynamic to match the API response
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  // Fetch the user ID from SharedPreferences
  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null && !JwtDecoder.isExpired(jwtToken)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
      userId = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

      if (userId != null) {
        setState(() => isAuthenticated = true);
        fetchWorkouts();
      }
    }

    setState(() => isLoading = false);
  }

  // Fetch workouts and then get the workout ID
  Future<void> fetchWorkouts() async {
    if (userId == null) return;

    final String apiUrl = 'https://10.0.2.2:7182/api/Workouts/GetWorkouts/$userId';

    final HttpClient client = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          workouts = data.map((item) => item as Map<String, dynamic>).toList(); // Cast dynamic to Map<String, dynamic>
          isLoading = false; // Set isLoading to false when data is fetched
        });

        // After fetching workouts, get the exercise count for each workout
        if (workouts.isNotEmpty) {
          for (var workout in workouts) {
            String workoutName = workout['name'];
            int exerciseCount = (workout['exercises'] as List).length;
            addChartData(workoutName, exerciseCount);
          }
        } else {
          print('No workouts available');
        }
      } else {
        print('Failed to fetch workouts.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching workouts: $e');
      setState(() {
        isLoading = false;
      });
    } finally {
      ioClient.close();
    }
  }

  // Add data to the chart (workout name vs exercise count)
  void addChartData(String workoutName, int exerciseCount) {
    setState(() {
      chartData.add(FlSpot(chartData.length.toDouble(), exerciseCount.toDouble()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : isAuthenticated
                ? Stack(
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
                            'https://st.depositphotos.com/9527076/55730/i/450/depositphotos_557301200-stock-photo-fitness-or-exercising-at-home.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Column(
                      children: [
                        const SizedBox(height: 50,),
                        const Text('Exercise Count', style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),),
                        const SizedBox(height: 10,),
                          Container(
                            height: 400, // Set the height to your desired value
                            padding: const EdgeInsets.all(16), // Add some padding
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: Colors.grey.withAlpha(100),
                                    strokeWidth: 1,
                                  ),
                                  getDrawingVerticalLine: (value) => FlLine(
                                    color: Colors.grey.withAlpha(100),
                                    strokeWidth: 1,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false, // Hide titles on the X-axis
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true, // Show titles on the Y-axis
                                      reservedSize: 32, // Adjust the space
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        );
                                      },
                                      interval: 1, // Show natural numbers only
                                    ),
                                  ),
                                  // Hide the top and right titles
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                    color: Colors.black.withAlpha(20),
                                    width: 1,
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: chartData,
                                    isCurved: false,
                                    belowBarData: BarAreaData(show: false), // Remove the shaded area below the line
                                    barWidth: 3, // Set the width of the line
                                  ),
                                ],
                                minY: 0, // Set the minimum Y-axis value
                                maxY: chartData.isNotEmpty
                                    ? chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1
                                    : 1, // Adjust the max Y value
                              ),
                            ),
                          ),
                        ],
                    ),
                  ],
                )
                : const CircularProgressIndicator(),
      ),
    );
  }
}
