import 'package:flutter/material.dart';
import 'dart:async';

class UserSuccessStories extends StatefulWidget {
  const UserSuccessStories({super.key});

  @override
  UserSuccessStoriesState createState() => UserSuccessStoriesState();
}

class UserSuccessStoriesState extends State<UserSuccessStories> {
  final List<Map<String, String>> successStories = [
    {
      "name": "John Doe",
      "story": "Lost 20 pounds in 3 months by following a balanced workout and nutrition plan.",
      "image": "https://www.profilebakery.com/wp-content/uploads/2024/05/Profile-picture-created-with-ai.jpeg", // Add the image URL for John
    },
    {
      "name": "Jane Smith",
      "story": "Ran her first marathon after six months of consistent training and perseverance.",
      "image": "https://www.profilebakery.com/wp-content/uploads/2023/04/women-AI-Profile-Picture.jpg", // Add the image URL for Jane
    },
    {
      "name": "Emily White",
      "story": "Increased her bench press by 50% and built lean muscle through weight training.",
      "image": "https://www.lensrentals.com/blog/media/2024/02/138_image_eefb46bf-81e5-44c0-82a3-a898116c3774.png", // Add the image URL for Emily
    },
  ];

  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  // Function to automatically change the page every 2 seconds
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentPage < successStories.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Ensure the timer is canceled when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Center(
          child: Text(
            "User Success Stories",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 250, // Adjust the height as needed
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: successStories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40, // Size of the profile image
                            backgroundImage: NetworkImage(successStories[index]["image"]!),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            successStories[index]["name"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              successStories[index]["story"]!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withAlpha(200),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(successStories.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 16 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
