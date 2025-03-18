import 'dart:convert';
import 'dart:io';
import 'package:fitness_app/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
//import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Function to make API call
  Future<void> registerUser() async {
    final String apiUrl =
        'https://10.0.2.2:7182/api/users/register'; // Correct URL with '/api/register' for Android Emulator

    // Create a custom HttpClient to bypass SSL certificate verification
    final HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  true; // Bypass SSL

    // Create an IOClient using the custom HttpClient
    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration Successful! You may proceed to sign in.',
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Registration failed
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration Failed!')));
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      // Close the IOClient to free resources
      ioClient.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: registerUser, child: Text('Register')),
          ],
        ),
      ),
    );
  }
}
