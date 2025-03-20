import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  bool isLoading = true;
  Map<DateTime, List<Map<String, dynamic>>> plannersByDate = {};
  String? userId;
  DateTime selectedDay = DateTime.now();

  // HTTP client to bypass SSL errors
  final HttpClient client =
      HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
  late final IOClient ioClient;

  @override
  void initState() {
    super.initState();
    ioClient = IOClient(client);
    _getUserId();
  }

  // Fetch userId from shared preferences
  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
        userId =
            decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
        if (userId != null) {
          setState(() {
            userId = userId;
          });
          _fetchPlanners();
        } else {
          print("Failed to extract userId from JWT token.");
        }
      } catch (e) {
        print("Error decoding JWT: $e");
      }
    }
  }

  // Fetch planners from API
  Future<void> _fetchPlanners() async {
  if (userId == null) return;

  setState(() {
    isLoading = true;
  });

  try {
    final response = await ioClient.get(
      Uri.parse('https://10.0.2.2:7182/api/Planners/GetPlannersByUserId/$userId'),
    );

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> planners = List<Map<String, dynamic>>.from(json.decode(response.body));

      setState(() {
        plannersByDate.clear();
        for (var planner in planners) {
          DateTime date = DateTime.parse(planner['date']).toLocal();
          DateTime normalizedDate = DateTime(date.year, date.month, date.day);  // Normalize the date to remove the time part
          
          // Add planner to the map for the specific normalized date
          plannersByDate.putIfAbsent(normalizedDate, () => []).add(planner);
        }
        print(plannersByDate);  // Print plannersByDate for debugging
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load planners");
    }
  } catch (e) {
    print("Error fetching planners: $e");
    setState(() {
      isLoading = false;
    });
  }
}

  // Add a new planner
  Future<void> _addPlanner(
    String title,
    String description,
    DateTime date,
  ) async {
    if (userId == null) return;

    try {
      final response = await ioClient.post(
        Uri.parse('https://10.0.2.2:7182/api/Planners/PostPlanner'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'title': title,
          'description': description,
          'date': date.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        _fetchPlanners();
      } else {
        throw Exception("Failed to add planner");
      }
    } catch (e) {
      print("Error adding planner: $e");
    }
  }

  // Edit an existing planner
  Future<void> _editPlanner(
    int plannerId,
    String title,
    String description,
    DateTime date,
  ) async {
    if (userId == null) return;

    try {
      final response = await ioClient.put(
        Uri.parse('https://10.0.2.2:7182/api/Planners/PutPlanner/$plannerId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'title': title,
          'description': description,
          'date': date.toIso8601String(),
        }),
      );

      if (response.statusCode == 204) {
        _fetchPlanners();
      } else {
        throw Exception("Failed to edit planner");
      }
    } catch (e) {
      print("Error editing planner: $e");
    }
  }

  // Delete a planner
  Future<void> _deletePlanner(int plannerId) async {
    try {
      final response = await ioClient.delete(
        Uri.parse(
          'https://10.0.2.2:7182/api/Planners/DeletePlanner/$plannerId',
        ),
      );

      if (response.statusCode == 204) {
        _fetchPlanners();
      } else {
        throw Exception("Failed to delete planner");
      }
    } catch (e) {
      print("Error deleting planner: $e");
    }
  }

  // Show dialog to add/edit planner
  void _showPlannerDialog({
    int? plannerId,
    String? currentTitle,
    String? currentDescription,
    DateTime? currentDate,
  }) {
    TextEditingController titleController = TextEditingController(
      text: currentTitle,
    );
    TextEditingController descriptionController = TextEditingController(
      text: currentDescription,
    );
    DateTime selectedDate = currentDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(plannerId == null ? 'Add Planner' : 'Edit Planner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  'Select Date: ${selectedDate.toLocal()}'.split(' ')[0],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (plannerId == null) {
                  _addPlanner(
                    titleController.text,
                    descriptionController.text,
                    selectedDate,
                  );
                } else {
                  _editPlanner(
                    plannerId,
                    titleController.text,
                    descriptionController.text,
                    selectedDate,
                  );
                }
                Navigator.pop(context);
                _fetchPlanners();
              },
              child: const Text('Save'),
            ),
          ],
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
            icon: const Icon(Icons.add),
            onPressed: () => _showPlannerDialog(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
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
              // child: Image.network(
              //   'https://img.freepik.com/premium-photo/strong-athletic-woman-sprinter-running-black-background_1235831-49749.jpg',
              //   fit: BoxFit.cover,
              // ),
            ),
          ),

          // Calendar
          Column(
            children: [
              TableCalendar(
                focusedDay: selectedDay,
                firstDay: DateTime(2020),
                lastDay: DateTime(2100),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                eventLoader: (day) {
                  DateTime normalizedDate = DateTime(
                    day.year,
                    day.month,
                    day.day,
                  );
                  return plannersByDate[normalizedDate] ?? [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    this.selectedDay = selectedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Display planners for selected day
             Expanded(
  child: isLoading
      ? const Center(child: CircularProgressIndicator())
      : plannersByDate[selectedDay?.toLocal().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)]?.isEmpty ?? true
          ? const Center(child: Text("No plans for this day"))
          : ListView.builder(
              itemCount: plannersByDate[selectedDay?.toLocal().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)]?.length ?? 0,
              itemBuilder: (context, index) {
                var planner = plannersByDate[selectedDay?.toLocal().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)]![index];
                return ListTile(
                  title: Text(planner['title']),
                  subtitle: Text(planner['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showPlannerDialog(
                          plannerId: planner['id'],
                          currentTitle: planner['title'],
                          currentDescription: planner['description'],
                          currentDate: DateTime.parse(planner['date']),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePlanner(planner['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
)

            ],
          ),
        ],
      ),
    );
  }
}
