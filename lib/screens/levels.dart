import 'package:Quipia/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:Quipia/repositories/quiz/quiz_repository.dart';
import 'package:Quipia/enums/difficulty.dart';
import 'screens.dart';

class LevelsPage extends StatefulWidget {
  final int id;
  final int numOfQuestions;

  LevelsPage(this.id, this.numOfQuestions);
  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  @override
  Widget build(BuildContext context) {
    final quizQuestionsProviderEasy =
        FutureProvider.autoDispose<List<Question>>(
      (ref) => ref.watch(quizRepositoryProvider).getQuestions(
            numQuestions: widget.numOfQuestions,
            categoryId: widget.id,
            difficulty: Difficulty.easy,
          ),
    );

    final quizQuestionsProviderMedium =
        FutureProvider.autoDispose<List<Question>>(
      (ref) => ref.watch(quizRepositoryProvider).getQuestions(
            numQuestions: widget.numOfQuestions,
            categoryId: widget.id,
            difficulty: Difficulty.medium,
          ),
    );

    final quizQuestionsProviderHard =
        FutureProvider.autoDispose<List<Question>>(
      (ref) => ref.watch(quizRepositoryProvider).getQuestions(
            numQuestions: widget.numOfQuestions,
            categoryId: widget.id,
            difficulty: Difficulty.hard,
          ),
    );

    const curveHeight = 30.0;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  centerTitle: true,
                  toolbarHeight: 80,
                  title: Text("Pick a Level",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey[300],
                      )),
                  shape: const MyShapeBorder(curveHeight),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 50)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizPage(quizQuestionsProviderEasy)),
                );
              },
              child: CardListTile(
                title: "Level 1",
                subtitle: "Unlocked",
                unlocked: true,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizPage(quizQuestionsProviderEasy)),
                );
              },
              child: CardListTile(
                title: "Level 2",
                subtitle: "Locked",
                unlocked: false,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizPage(quizQuestionsProviderMedium)),
                );
              },
              child: CardListTile(
                title: "Level 3",
                subtitle: "Locked",
                unlocked: false,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizPage(quizQuestionsProviderMedium)),
                );
              },
              child: CardListTile(
                title: "Level 4",
                subtitle: "Locked",
                unlocked: false,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizPage(quizQuestionsProviderHard)),
                );
              },
              child: CardListTile(
                title: "Level 5",
                subtitle: "Locked",
                unlocked: false,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizPage(quizQuestionsProviderHard)),
                );
              },
              child: CardListTile(
                title: "Level 6",
                subtitle: "Locked",
                unlocked: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
