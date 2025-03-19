import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final String imageUrl;
  final String description;

  Exercise({
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}

class ExerciseLibrary extends StatefulWidget {
  const ExerciseLibrary ({super.key});
  @override
  ExerciseLibraryState createState() => ExerciseLibraryState();
}

class ExerciseLibraryState extends State<ExerciseLibrary> {
final List<Exercise> exercises = [
    Exercise(
      name: 'Push Up',
      imageUrl:
          'https://images.unsplash.com/photo-1616803689943-5601631c7fec?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHVzaCUyMHVwfGVufDB8fDB8fHww',
      description:
          '- Start in a high plank position with hands shoulder-width apart.\n- Lower your body until your chest nearly touches the floor.\n- Keep your elbows at a 45-degree angle.\n- Push back up to the starting position.\n- Engage your core throughout the movement.',
    ),
    Exercise(
      name: 'Squat',
      imageUrl:
          'https://media.istockphoto.com/id/1370779476/photo/shot-of-a-sporty-young-woman-exercising-with-a-barbell-in-a-gym.jpg?s=612x612&w=0&k=20&c=h0-7W838WAKjybISdAsqemZ2mrtek66T5W9t22PfLYw=',
      description:
          '- Stand with feet shoulder-width apart.\n- Lower your hips as if sitting in a chair.\n- Keep your back straight and chest up.\n- Go down until thighs are parallel to the floor.\n- Push through your heels to return to standing.',
    ),
    Exercise(
      name: 'Plank',
      imageUrl:
          'https://media.istockphoto.com/id/628092382/photo/its-great-for-the-abs.jpg?s=612x612&w=0&k=20&c=YOWaZRjuyh-OG6rv8k0quDNxRwqrxdMm8xgqe37Jmak=',
      description:
          '- Lie face down and place forearms on the floor.\n- Lift your body, keeping it in a straight line from head to heels.\n- Engage your core and avoid sagging your hips.\n- Hold the position for the desired duration.',
    ),
    Exercise(
      name: 'Lunges',
      imageUrl:
          'https://media.istockphoto.com/id/1051627106/photo/helping-him-to-achieve-his-fitness-goals.jpg?s=612x612&w=0&k=20&c=ka9FZTNqpQccAx1JG-EYbvJauE8xqxgZYjyLTOlGnKs=',
      description:
          '- Stand tall with feet hip-width apart.\n- Step forward with one leg and lower your body.\n- Keep your front knee aligned with your ankle.\n- Push back to the starting position and repeat on the other leg.',
    ),
    // Additional 8 exercises
    Exercise(
      name: 'Deadlift',
      imageUrl:
          'https://t3.ftcdn.net/jpg/04/85/64/08/360_F_485640894_Ek9L59TH3BBBCNhFDjNNEMibaxOzK3Cj.jpg',
      description:
          '- Stand with feet hip-width apart, barbell in front.\n- Hinge at your hips, grip the barbell, and keep your back straight.\n- Lift the barbell by extending your hips and knees.\n- Lower the barbell back down with control.',
    ),
    Exercise(
      name: 'Bench Press',
      imageUrl:
          'https://media.istockphoto.com/id/1028273740/photo/man-during-bench-press-exercise.jpg?s=612x612&w=0&k=20&c=pTNDqP6UbgTm39u9GHFqDiH13o1cm1l4xYHBdoiSdkg=',
      description:
          '- Lie on a flat bench and grip the barbell slightly wider than shoulder-width.\n- Lower the bar to your chest while keeping elbows at 45 degrees.\n- Press the bar back up until arms are fully extended.',
    ),
    Exercise(
      name: 'Pull Up',
      imageUrl:
          'https://i0.wp.com/post.healthline.com/wp-content/uploads/2019/12/pull-up-pullup-gym-1296x728-header-1296x728.jpg?w=1155&h=1528',
      description:
          '- Grip the pull-up bar with palms facing away.\n- Hang with arms fully extended.\n- Pull your chin above the bar.\n- Lower back down in a controlled motion.',
    ),
    Exercise(
      name: 'Dips',
      imageUrl:
          'https://media.istockphoto.com/id/1008346250/photo/disabled-young-man-working-on-arms-dips-exercise.jpg?s=612x612&w=0&k=20&c=YI8dmSwLqTMChYocL1xM75Ii0YkTOiaSr9qthfkbJOc=',
      description:
          '- Grip parallel bars and support your body with arms extended.\n- Lower yourself until elbows are at 90 degrees.\n- Push back up to the starting position.',
    ),
    Exercise(
      name: 'Bicep Curl',
      imageUrl:
          'https://media.istockphoto.com/id/1486887865/photo/a-focused-sportsman-is-sitting-in-a-gym-and-doing-exercises-for-the-biceps-and-triceps-with-a.jpg?s=612x612&w=0&k=20&c=x9mDswt4N78flocXT0neJ0qSjt2BhMDs1LUwg4aVkaE=',
      description:
          '- Hold dumbbells with palms facing forward.\n- Curl the dumbbells toward your shoulders.\n- Lower them slowly to the starting position.',
    ),
    Exercise(
      name: 'Leg Press',
      imageUrl:
          'https://media.istockphoto.com/id/1285187444/photo/woman-in-her-20s-exercsing-with-a-leg-press-machine.jpg?s=612x612&w=0&k=20&c=0xlNZqVBNS1xCOOwYTkXsCcNhNEnuJ4SmezIWDZQUzM=',
      description:
          '- Sit on the leg press machine with feet shoulder-width apart.\n- Push the platform away until legs are extended.\n- Slowly lower back down.',
    ),
    Exercise(
      name: 'Shoulder Press',
      imageUrl:
          'https://t4.ftcdn.net/jpg/01/26/84/35/360_F_126843544_nX6e9GptzvqopKNeDijOqEydITQc0ESd.jpg',
      description:
          '- Hold dumbbells at shoulder height.\n- Press them overhead until arms are fully extended.\n- Lower back to starting position.',
    ),
    Exercise(
      name: 'Russian Twist',
      imageUrl:
          'https://media.istockphoto.com/id/1363075272/photo/woman-doing-russian-twists-with-a-medicine-ball.jpg?s=612x612&w=0&k=20&c=SoFH8BXCdjB9VGig2J6yuqFMcUhz2mjIhws7YzCyiAU=',
      description:
          '- Sit on the floor with knees bent.\n- Lean back slightly and twist your torso side to side.\n- Hold a weight or medicine ball for added intensity.',
    ),
  ];
  List<Exercise> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    filteredExercises = exercises;
  }

  void _filterExercises(String query) {
    setState(() {
      filteredExercises = exercises
          .where((exercise) => exercise.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                'https://images.unsplash.com/photo-1542684377-0b875fde9563?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z3ltJTIwYmFja2dyb3VuZHxlbnwwfHwwfHx8MA%3D%3D',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search exercises...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: _filterExercises,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = filteredExercises[index];
                    return GestureDetector(
                      onTap: () => _showExerciseModal(context, exercise),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(exercise.imageUrl, fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                exercise.name,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExerciseModal(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  exercise.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                exercise.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                exercise.description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}