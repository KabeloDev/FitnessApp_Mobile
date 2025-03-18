import 'dart:convert';
import 'dart:io';
import 'package:fitness_app/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  String profileImage = ''; // Stores selected profile picture URL
  bool isLoading = true;
  String errorMessage = '';
  String? userId;

  // Default profile picture if none is set
  final String defaultProfileImage =
      'https://cdn-icons-png.flaticon.com/512/149/149071.png';

  // List of 5 selectable profile images
  final List<String> profileImages = [
    'https://img.freepik.com/premium-vector/character-avatar-isolated_729149-194801.jpg?semt=ais_hybrid',
    'https://static.vecteezy.com/system/resources/previews/014/194/215/non_2x/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg',
    'https://img.freepik.com/premium-vector/avatar-teenager-icon-cartoon-style-faceless-men-isolated-white-background_98402-77340.jpg?w=360',
    'https://static.vecteezy.com/system/resources/previews/014/342/474/non_2x/anonymous-profile-icon-cartoon-style-vector.jpg',
    'https://static.vecteezy.com/system/resources/previews/014/194/198/non_2x/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg',
  ];

  // Fetch user data from API
  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
      userId =
          decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

      final String apiUrl =
          'https://10.0.2.2:7182/api/Users/GetUserById/$userId';

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
            _usernameController.text = data['username'] ?? '';
            _emailController.text = data['email'] ?? '';
            profileImage = data['profileImageUrl'] ?? defaultProfileImage;
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

  // Function to update user data
  Future<void> updateUserData() async {
    final String apiUrl = 'https://10.0.2.2:7182/api/Users/UpdateUser/$userId';

    final HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    final IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _usernameController.text,
          'email': _emailController.text,
          'profileImage': profileImage,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      ioClient.close();
    }
  }

  // Function to select a profile picture
  void selectProfileImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Profile Picture'),
          content: Wrap(
            spacing: 10,
            children:
                profileImages.map((image) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        profileImage = image;
                      });
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(image),
                      radius: 30,
                    ),
                  );
                }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Sign out function
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Successfully signed out')));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
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
              child: Image.network(
                'https://images.unsplash.com/photo-1637430308606-86576d8fef3c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZGFyayUyMGd5bXxlbnwwfHwwfHx8MA%3D%3D',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Profile Form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 10,
                color: Colors.white.withAlpha(200), // Slight transparency
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : errorMessage.isNotEmpty
                          ? Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red),
                          )
                          : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: selectProfileImage,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(profileImage),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                              ElevatedButton(
                                onPressed: updateUserData,
                                child: Text('Update Profile'),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: signOut,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text('Sign Out'),
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
