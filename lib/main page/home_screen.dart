import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_trainer/exercise%20screen/exercise_screen.dart';
import 'package:your_trainer/main%20page/exercise_widget.dart';
import 'package:your_trainer/models/exercise_model.dart';
import 'package:your_trainer/providers/exercise_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseProvider>(context, listen: false).loadExercises();
    });
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _userName = userDoc['name'];
      });
    }
  }

  void _navigateToExerciseScreen(Exercise exercise) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseScreen(
          exercise: exercise,
          reload: reload,
        ),
      ),
    );
  }

  void reload() {
    setState(() {
      Provider.of<ExerciseProvider>(context, listen: false).loadExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _userName == null ? "Welcome" : "Welcome, $_userName",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple,
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        "Let's start your workout",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height - 166,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Consumer<ExerciseProvider>(
                      builder: (context, exerciseProvider, child) {
                        if (exerciseProvider.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 7 / 4,
                          ),
                          itemCount: exerciseProvider.exercises.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ExerciseScreen(
                                      exercise:
                                          exerciseProvider.exercises[index],
                                      reload: reload,
                                    ),
                                  ),
                                );
                              },
                              child: ExerciseWidget(
                                exercise: exerciseProvider.exercises[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
