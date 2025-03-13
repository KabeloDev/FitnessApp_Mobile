import 'dart:developer';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_rounded, color: Colors.black),
            onPressed: () {
              log('Sign in clicked');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 89, 90, 90),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/736x/dc/9c/61/dc9c614e3007080a5aff36aebb949474.jpg',
                    ),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
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
                'https://www.ideafit.com/wp-content/uploads/2022/04/Run-Pacing.jpg',
                fit: BoxFit.cover, // Ensures the image covers the entire screen
              ),
            ),
          ),
          // Foreground Content
          ListView(
            padding: const EdgeInsets.all(15),
            children: [
              // Fitness App Title Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    158,
                    155,
                    155,
                  ).withAlpha(80), // Semi-transparent background
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Fitness App',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20), // Space before carousel
              // Horizontally Scrollable Gym Tips Carousel
              SizedBox(
                height: 160, // Fixed height for the cards
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildGymTipCard(
                        "Stay Hydrated",
                        "Drink at least 2L of water daily.",
                      ),
                      _buildGymTipCard(
                        "Warm-Up",
                        "Always warm up before lifting weights.",
                      ),
                      _buildGymTipCard(
                        "Proper Form",
                        "Focus on form over heavy weights.",
                      ),
                      _buildGymTipCard(
                        "Rest & Recovery",
                        "Muscles grow when you rest, not just when you train.",
                      ),
                      _buildGymTipCard(
                        "Consistency",
                        "Results come from discipline, not motivation.",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20), // Space before the motivational card
              // Motivational Card with Image and Button
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(230),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(0),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://wod.guru/wp-content/uploads/2024/07/7-2.jpg', // Replace with your image URL
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Encouraging text
                    const Text(
                      'Start Your Fitness Journey Today!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle registration action here
                          log('Start your journey button clicked');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          //primary: Colors.blueAccent,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Start your journey now'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Function to build each Gym Tip Card
Widget _buildGymTipCard(String title, String description) {
  return Container(
    width: 200, // Fixed width for each card
    margin: const EdgeInsets.only(right: 10), // Space between cards
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(
        220,
      ), // Slightly transparent white background
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(0),
          blurRadius: 5,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    ),
  );
}
