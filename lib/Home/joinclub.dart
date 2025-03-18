import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class JoinAClubSection extends StatefulWidget {
  const JoinAClubSection({super.key});
  @override
  JoinAClubSectionState createState() => JoinAClubSectionState();
}

class JoinAClubSectionState extends State<JoinAClubSection> {
  int expandedIndex = -1;

  List<Map<String, dynamic>> clubs = [
  {
    "title": "🏀 Sports Club",
    "description":
        "The Sports Club offers a dynamic and exciting environment where you can join competitive sports teams or casual games. Whether you are a seasoned player or just looking to stay active, our teams provide a great opportunity to improve your skills, compete, and enjoy the camaraderie of fellow members. From basketball to soccer, there’s always a game to join, no matter your level!",
    "color": const Color.fromARGB(255, 252, 253, 253),
  },
  {
    "title": "🤝 Social Club",
    "description":
        "The Social Club is the perfect place to meet and connect with like-minded fitness enthusiasts who share your passion for health and wellness. Whether you're looking for a workout buddy, a group to join for fitness events, or simply someone to talk to about your fitness journey, the Social Club fosters a welcoming, inclusive environment for all members. It's about building lasting friendships while working towards your fitness goals together!",
    "color": const Color.fromARGB(255, 252, 253, 253),
  },
  {
    "title": "🏃 Running Club",
    "description":
        "The Running Club is for those who enjoy pushing their limits and embracing the thrill of the run. Whether you’re training for your first marathon or just love running with a group, the Running Club offers various running events, group runs, and fitness challenges throughout the year. From casual jogs to intense training sessions, we support all levels of runners and encourage each other to go the extra mile!",
    "color": const Color.fromARGB(255, 252, 253, 253),
  },
];


  void toggleExpand(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Column(
          children: List.generate(clubs.length, (index) {
            bool isExpanded = expandedIndex == index;
            return GestureDetector(
              onTap: () => toggleExpand(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: clubs[index]["color"].withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: clubs[index]["color"],
                    width: isExpanded ? 3 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          clubs[index]["title"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: clubs[index]["color"],
                        ),
                      ],
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          clubs[index]["description"],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                  ],
                ),
              ).animate().scaleXY(
                  begin: 0.95, end: 1, duration: 300.ms, curve: Curves.easeInOut),
            );
          }),
        ),
      ],
    );
  }
}
