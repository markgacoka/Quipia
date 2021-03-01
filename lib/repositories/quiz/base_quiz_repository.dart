import 'package:Quipia/models/question_model.dart';
import 'package:Quipia/enums/difficulty.dart';

abstract class BaseQuizRepository {
  Future<List<Question>> getQuestions({
    int numQuestions,
    int categoryId,
    Difficulty difficulty,
  });
}
