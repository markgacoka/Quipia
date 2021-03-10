import 'package:Quipia/models/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool unlocked = true;
  bool unlockedEasy = false;
  bool unlockedMedium = false;
  bool unlockedHard = false;
  final int thresholdEasy = 500;
  final int thresholdMedium = 1000;
  final int thresholdHard = 5000;
  String currPointsLevels;
  int currPointsInt;

  @override
  void initState() {
    super.initState();
    setState(() {
      _getPointsDB().then((val) => setState(() {
            currPointsLevels = val;
            currPointsInt = int.tryParse(currPointsLevels);

            if (currPointsInt > thresholdEasy) {
              setState(() {
                unlockedEasy = true;
              });
            } else {
              setState(() {
                unlockedEasy = false;
              });
            }
            if (currPointsInt > thresholdMedium) {
              setState(() {
                unlockedMedium = true;
              });
            } else {
              setState(() {
                unlockedMedium = false;
              });
            }
            if (currPointsInt > thresholdHard) {
              setState(() {
                unlockedHard = true;
              });
            } else {
              setState(() {
                unlockedHard = false;
              });
            }
          }));
    });
  }

  Future<String> _getPointsDB() async {
    String currPoints;
    final String userUID = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('points')
        .where(FieldPath.documentId, isEqualTo: userUID)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        Map<String, dynamic> pointsData = event.docs.single.data();
        currPoints = pointsData['points'];
      }
    }).catchError((e) => print("error fetching data: $e"));
    return currPoints;
  }

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
                if (unlocked == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizPage(quizQuestionsProviderEasy)),
                  );
                } else {
                  return null;
                }
              },
              child: CardListTile(
                title: "Level 1",
                subtitle: "Unlocked",
                unlocked: unlocked,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                if (unlockedEasy == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizPage(quizQuestionsProviderEasy)),
                  );
                } else {
                  return null;
                }
              },
              child: CardListTile(
                title: "Level 2",
                subtitle: (unlockedEasy == true)
                    ? "Unlocked"
                    : "Locked. Unlock at ${thresholdEasy.toString()}",
                unlocked: unlockedEasy,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                if (unlockedMedium == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizPage(quizQuestionsProviderMedium)),
                  );
                } else {
                  return null;
                }
              },
              child: CardListTile(
                title: "Level 3",
                subtitle: (unlockedMedium == true)
                    ? "Unlocked"
                    : "Locked. Unlock at ${thresholdMedium.toString()}",
                unlocked: unlockedMedium,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                if (unlockedMedium == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizPage(quizQuestionsProviderMedium)),
                  );
                } else {
                  return null;
                }
              },
              child: CardListTile(
                title: "Level 4",
                subtitle: (unlockedMedium == true)
                    ? "Unlocked"
                    : "Locked. Unlock at ${thresholdMedium.toString()}",
                unlocked: unlockedMedium,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                if (unlockedHard == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizPage(quizQuestionsProviderHard)),
                  );
                } else {
                  return null;
                }
              },
              child: CardListTile(
                title: "Level 5",
                subtitle: (unlockedHard == true)
                    ? "Unlocked"
                    : "Locked. Unlock at ${thresholdHard.toString()}",
                unlocked: unlockedHard,
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                if (unlockedHard == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizPage(quizQuestionsProviderHard)),
                  );
                } else {
                  return null;
                }
              },
              child: CardListTile(
                  title: "Level 6",
                  subtitle: (unlockedHard == true)
                      ? "Unlocked"
                      : "Locked. Unlock at ${thresholdHard.toString()}",
                  unlocked: unlockedHard),
            ),
          ],
        ),
      ),
    );
  }
}
