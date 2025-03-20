import 'dart:convert';
import 'dart:io';
import 'package:fitness_app/Planner/calendar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/io_client.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  bool isLoading = true;
  bool isAuthenticated = false;
  List<Map<String, String>> workouts = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null && !JwtDecoder.isExpired(jwtToken)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
      userId =
          decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

      if (userId != null) {
        setState(() => isAuthenticated = true);
        fetchWorkouts();
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> fetchWorkouts() async {
    if (userId == null) return;

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
        List<dynamic> data = json.decode(response.body);
        setState(() {
          workouts =
              data
                  .map(
                    (item) => {
                      'id': item['id'].toString(),
                      'name': item['name'].toString(),
                      'status': item['status'].toString(),
                    },
                  )
                  .toList();
        });
      } else {
        print('Failed to fetch workouts.');
      }
    } catch (e) {
      print('Error fetching workouts: $e');
    } finally {
      ioClient.close();
    }
  }

  Future<void> addWorkout(String name) async {
    if (userId == null) return;

    final String apiUrl = 'https://10.0.2.2:7182/api/Workouts/CreateWorkout';

    final HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'name': name}),
      );

      if (response.statusCode == 200) fetchWorkouts();
    } catch (e) {
      print('Error adding workout: $e');
    } finally {
      ioClient.close();
    }
  }

  Future<void> editWorkout(String workoutId, String name, String status) async {
    final String apiUrl =
        'https://10.0.2.2:7182/api/Workouts/UpdateWorkout/$workoutId';

    final HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'name': name, 'status': status}),
      );

      if (response.statusCode == 200) fetchWorkouts();
    } catch (e) {
      print('Error updating workout: $e');
    } finally {
      ioClient.close();
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    final String apiUrl =
        'https://10.0.2.2:7182/api/Workouts/DeleteWorkout/$workoutId';

    final HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) fetchWorkouts();
    } catch (e) {
      print('Error deleting workout: $e');
    } finally {
      ioClient.close();
    }
  }

  void showWorkoutDialog({
    String? workoutId,
    String? currentTitle,
    String? currentStatus,
  }) {
    TextEditingController nameController = TextEditingController(
      text: currentTitle,
    );
    String selectedStatus = currentStatus ?? 'In Progress'; // Default status

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(workoutId == null ? 'Add Workout' : 'Edit Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Workout Name'),
              ),

              SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(labelText: 'Status'),
                items:
                    ['In Progress', 'Incomplete', 'Complete'].map((
                      String status,
                    ) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    selectedStatus = newValue;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (workoutId == null) {
                  addWorkout(nameController.text);
                } else {
                  editWorkout(workoutId, nameController.text, selectedStatus);
                }
                Navigator.pop(context);
                fetchWorkouts();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showAddExerciseDialog(String workoutId) {
    TextEditingController nameController = TextEditingController();
    TextEditingController setsController = TextEditingController();
    TextEditingController repsController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Exercise Name'),
              ),
              TextField(
                controller: setsController,
                decoration: InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: repsController,
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time (minutes)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                addExerciseToWorkout(
                  workoutId,
                  nameController.text,
                  setsController.text,
                  repsController.text,
                  timeController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addExerciseToWorkout(
    String workoutId,
    String name,
    String sets,
    String reps,
    String time,
  ) async {
    final String apiUrl =
        'https://10.0.2.2:7182/api/Workouts/AddExercise/$workoutId';

    final HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'sets': int.tryParse(sets) ?? 0,
          'reps': int.tryParse(reps) ?? 0,
          'time': time,
        }),
      );

      if (response.statusCode == 200) {
        print('Exercise added successfully.');
      } else {
        print('Failed to add exercise.');
      }
    } catch (e) {
      print('Error adding exercise: $e');
    } finally {
      ioClient.close();
    }
  }

  Future<List<Map<String, String>>> fetchExercises(String workoutId) async {
    final String apiUrl =
        'https://10.0.2.2:7182/api/Workouts/GetExercises/$workoutId';

    final HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data
            .map(
              (item) => {
                'name': item['name'].toString(),
                'sets': item['sets'].toString(),
                'reps': item['reps'].toString(),
                'time': item['time'].toString(),
              },
            )
            .toList();
      } else {
        print('Failed to fetch exercises.');
        return [];
      }
    } catch (e) {
      print('Error fetching exercises: $e');
      return [];
    } finally {
      ioClient.close();
    }
  }

  void showExercisesModal(String workoutId) async {
    List<Map<String, String>> exercises = await fetchExercises(workoutId);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Scaffold(
            appBar: AppBar(),
            body:
                exercises.isEmpty
                    ? Center(child: Text('No exercises found'))
                    : Stack(
                      children: [
                        Positioned.fill(
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white.withAlpha(0),
                                ],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              'https://www.shutterstock.com/shutterstock/videos/1018213108/thumb/1.jpg?ip=x480',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(exercises[index]['name']!),
                                subtitle: Text(
                                  'Sets: ${exercises[index]['sets']} | Reps: ${exercises[index]['reps']} | Time: ${exercises[index]['time']} min',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showWorkoutDialog(),
          ),
        ],
      ),
      body: Center(
        child:
            isLoading
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
                          'https://st3.depositphotos.com/8893426/18502/i/450/depositphotos_185029320-stock-photo-fitness-background-with-dumbbells-view.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: workouts.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    workouts[index]['name']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    workouts[index]['status']!,
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                        onPressed:
                                            () => showWorkoutDialog(
                                              workoutId: workouts[index]['id'],
                                              currentTitle:
                                                  workouts[index]['name'],
                                              currentStatus:
                                                  workouts[index]['status'],
                                            ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                        ),
                                        onPressed:
                                            () => deleteWorkout(
                                              workouts[index]['id']!,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.grey,
                                        ),
                                        onPressed:
                                            () => showAddExerciseDialog(
                                              workouts[index]['id']!,
                                            ),
                                      ),

                                      IconButton(
                                        icon: Icon(
                                          Icons.open_in_full,
                                          color: Colors.grey,
                                        ),
                                        onPressed:
                                            () => showExercisesModal(
                                              workouts[index]['id']!,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
                : const CircularProgressIndicator(),
      ),
    );
  }
}
