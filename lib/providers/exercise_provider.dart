import 'package:flutter/material.dart';
import 'package:your_trainer/models/exercise_model.dart';
import 'package:your_trainer/repository/exercise_repository.dart';

class ExerciseProvider with ChangeNotifier {
  final ExerciseRepository _exerciseRepository = ExerciseRepository();
  List<Exercise> _exercises = [];
  bool _isLoading = false;

  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;

  Future<void> loadExercises({int limit = 200, int offset = 0}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _exercises = await _exerciseRepository.fetchExercises(
          limit: limit, offset: offset);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
