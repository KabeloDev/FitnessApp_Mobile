import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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

  // Function to fetch user data
  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwt_token');
    
    if (jwtToken != null) {
      // Decode the JWT token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);

      // Extract the 'nameidentifier' claim (which represents the user ID)
      userId = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

      final String apiUrl = 'https://10.0.2.2:7182/api/Users/GetUserById/$userId'; // Use the decoded user ID

      // Create a custom HttpClient to bypass SSL certificate verification
      final HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true; // Bypass SSL

      // Create an IOClient using the custom HttpClient
      final IOClient ioClient = IOClient(client);

      try {
        final response = await ioClient.get(
          Uri.parse(apiUrl),
        );

        if (response.statusCode == 200) {
          // Parse response body
          final Map<String, dynamic> data = json.decode(response.body);
          setState(() {
            username = data['username'];  // Assuming the response has a 'username' field
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Failed to load user data.';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Error: $e';
          isLoading = false;
        });
      } finally {
        ioClient.close();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator() // Show loading spinner while fetching data
              : errorMessage.isNotEmpty
                  ? Text(errorMessage) // Show error if there's an issue
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome, $username!', // Display the username
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
