import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoTutorialsOfTheWeek extends StatelessWidget {
  VideoTutorialsOfTheWeek({super.key});

  final List<Map<String, String>> videoTutorials = [
    {
      "title": "How to Perfect Your Squats",
      "url": "eFEVKmp3M4g", // YouTube Video ID
      "thumbnail":
          "https://media.istockphoto.com/id/1412656736/video/online-workout-service-professional-trainer-explaining-exercise-virtual-video-tutorial-for.jpg?s=640x640&k=20&c=55-LqNejMLtfUE7roxSDUkvSwDpax_LmDnC-Ti8Ieco=", // YouTube Thumbnail Image URL
    },
    {
      "title": "Top 5 Core Exercises",
      "url": "7FzVZ58iCZo", // YouTube Video ID
      "thumbnail":
          "https://media.gettyimages.com/id/1404045347/video/female-doing-core-exercises-in-the-park-mixed-race-athlete-doing-ab-exercises-outdoors-woman.jpg?s=640x640&k=20&c=tnh6cX70O_3_aWTRDvfVAHTsxUiF9UCRDHb6UVAUZio=", // YouTube Thumbnail Image URL
    },
    {
      "title": "Chest Workout for Beginners",
      "url": "CfvPJ8kH_L8", // YouTube Video ID
      "thumbnail":
          "https://media.gettyimages.com/id/1493195861/video/body-builder-training-hard.jpg?s=640x640&k=20&c=kC18FG5WtdCYhlBbWeHS2up7FzKw06Ny-u4AwEVWpBY=", // YouTube Thumbnail Image URL
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Center(
          child: Text(
            "Video Tutorials of the Week",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Column(
          children: videoTutorials.map((tutorial) {
            return GestureDetector(
              onTap: () {
                // Show the video in a modal dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.black.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: VideoPlayerModal(videoId: tutorial["url"]!),
                    );
                  },
                );
              },
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
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(tutorial["thumbnail"]!),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        tutorial["title"]!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class VideoPlayerModal extends StatefulWidget {
  final String videoId;

  const VideoPlayerModal({super.key, required this.videoId});

  @override
  _VideoPlayerModalState createState() => _VideoPlayerModalState();
}

class _VideoPlayerModalState extends State<VideoPlayerModal> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Close Button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          // Video Player
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
          ),
        ],
      ),
    );
  }
}
