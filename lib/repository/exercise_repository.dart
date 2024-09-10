import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:your_trainer/models/exercise_model.dart';

class ExerciseRepository {
  final String apiKey = 'cac409c915msh9ab9f30ddf603a4p191332jsn00cbcaba5982';
  final String apiHost = 'exercisedb.p.rapidapi.com';

  Future<List<Exercise>> fetchExercises(
      {int limit = 200, int offset = 0}) async {
    final response = await http.get(
      Uri.https(apiHost, '/exercises', {
        'limit': '$limit',
        'offset': '$offset',
      }),
      headers: {
        'X-Rapidapi-Key': apiKey,
        'X-Rapidapi-Host': apiHost,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Exercise> exercises =
          jsonResponse.map((json) => Exercise.fromJson(json)).toList();

      // Filter out exercises with names longer than two words
      exercises = exercises
          .where((exercise) => exercise.name.split(' ').length <= 2)
          .toList();

      return exercises;
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
