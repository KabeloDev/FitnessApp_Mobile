import 'dart:developer';
import 'package:fitness_app/joinclub.dart';
import 'package:fitness_app/stories.dart';
import 'package:fitness_app/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                'https://img.freepik.com/premium-photo/man-running-black-background_980736-8479.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(15),
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 80,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildGymTipCard(
                        context,
                        "Stay Hydrated",
                        "Drink at least 2L of water daily.",
                        'https://media.istockphoto.com/id/1372307016/photo/shot-of-a-young-woman-taking-a-break-from-working-out-to-drink-water.jpg?s=612x612&w=0&k=20&c=cdWNquuOodtnRBrJ7x1_sHlD9gnMrIKCEU2SIaKbAnQ=',
                      ),
                      _buildGymTipCard(
                        context,
                        "Warm-Up",
                        "Always warm up before lifting weights.",
                        'https://cdn.outsideonline.com/wp-content/uploads/2020/03/26/no-warm-up_s.jpg',
                      ),
                      _buildGymTipCard(
                        context,
                        "Proper Form",
                        "Focus on form over heavy weights.",
                        'https://recxpress.com.au/wp-content/uploads/2019/05/The-Importance-of-Good-Weightlifting-Form-and-How-to-Improve-Your-Technique.jpg',
                      ),
                      _buildGymTipCard(
                        context,
                        "Rest & Recovery",
                        "Muscles grow when you rest, not just when you train.",
                        'https://tropeaka.com/cdn/shop/articles/7-reasons-to-take-rest-and-recovery-more-seriously-main_2000x.jpg?v=1572852067',
                      ),
                      _buildGymTipCard(
                        context,
                        "Consistency",
                        "Results come from discipline, not motivation.",
                        'https://www.planetfitness.com/sites/default/files/feature-image/SEO%20Blog%20Article_Header%20Image_Building%20Consistency_%20Tips%20for%20Maintaining%20Motivation%20in%20Your%20Gym%20Routine.jpg',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(150),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://wod.guru/wp-content/uploads/2024/07/7-2.jpg',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Take the first step toward a healthier, stronger, and more confident you—start your fitness journey today!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          log('Start your journey button clicked');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
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
              const SizedBox(height: 20),
              Center(
                child: const Text(
                  'Join one of exclusive clubs!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              JoinAClubSection(),
              const SizedBox(height: 20),
              VideoTutorialsOfTheWeek(),
              const SizedBox(height: 20),
              UserSuccessStories(),
              _buildSocialMediaFooter(),
            ],
          ),
        ],
      ),
    );
  }
}



Widget _buildGymTipCard(
  BuildContext context,
  String title,
  String description,
  String imageUrl,
) {
  return GestureDetector(
    onTap: () => _showTipModal(context, title, description, imageUrl),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 200,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 247, 247).withAlpha(100),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(0),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

// Social media footer
  Widget _buildSocialMediaFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.facebook, size: 30, color: Color.fromARGB(255, 1, 71, 128)),
          onPressed: () {
            log('Facebook clicked');
            // Add your Facebook link here
          },
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.twitter, size: 30, color: Colors.blue),
          onPressed: () {
            log('Twitter clicked');
            // Add your Twitter link here
          },
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.instagram, size: 30, color: Colors.purple),
          onPressed: () {
            log('Instagram clicked');
            // Add your Instagram link here
          },
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.youtube, size: 30, color: Colors.red),
          onPressed: () {
            log('YouTube clicked');
            // Add your YouTube link here
          },
        ),
      ],
    );
}


void _showTipModal(
  BuildContext context,
  String title,
  String description,
  String imageUrl,
) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              SizedBox(height: 10),
              Text(description),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
  );
}


