import 'package:Quipia/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:Quipia/controllers/quiz/quiz_controller.dart';
import 'package:Quipia/controllers/quiz/quiz_state.dart';
import 'package:Quipia/models/failure_model.dart';
import 'package:Quipia/models/question_model.dart';
import 'package:Quipia/repositories/quiz/quiz_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:like_button/like_button.dart';

class QuizPage extends HookWidget {
  QuizPage(this.quizQuestionsProvider);
  final quizQuestionsProvider;

  @override
  Widget build(BuildContext context) {
    final quizQuestions = useProvider(quizQuestionsProvider);

    final pageController = usePageController();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Theme.of(context).canvasColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
          data: (questions) => _buildBody(context, pageController, questions),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => QuizError(
            message: error is Failure ? error.message : 'Something went wrong!',
          ),
        ),
        bottomSheet: quizQuestions.maybeWhen(
          data: (questions) {
            final quizState = useProvider(quizControllerProvider.state);
            if (!quizState.answered) return const SizedBox.shrink();
            return CustomButton(
                title: pageController.page.toInt() < questions.length
                    ? 'Next Question'
                    : 'See Results',
                onTap: () async {
                  context
                      .read(quizControllerProvider)
                      .nextQuestion(questions, pageController.page.toInt());
                  if (pageController.page.toInt() + 1 < questions.length) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 20),
                      curve: Curves.linear,
                    );
                  }
                },
                color: Theme.of(context).buttonColor,
                color2: Colors.black);
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PageController pageController,
    List<Question> questions,
  ) {
    if (questions.isEmpty) return QuizError(message: 'Coming Soon...');

    final quizState = useProvider(quizControllerProvider.state);
    return quizState.status == QuizStatus.complete
        ? QuizResults(state: quizState, questions: questions)
        : QuizQuestions(
            pageController: pageController,
            state: quizState,
            questions: questions,
          );
  }
}

class QuizQuestions extends StatefulWidget {
  final PageController pageController;
  final QuizState state;
  final List<Question> questions;

  const QuizQuestions({
    Key key,
    @required this.pageController,
    @required this.state,
    @required this.questions,
  }) : super(key: key);

  @override
  _QuizQuestionsState createState() => _QuizQuestionsState();
}

class _QuizQuestionsState extends State<QuizQuestions> {
  int points = 0;
  String url =
      "https://assets.mixkit.co/sfx/preview/mixkit-simple-game-countdown-921.mp3";

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.questions.length,
      itemBuilder: (BuildContext context, int index) {
        final question = widget.questions[index];
        return Padding(
          padding: EdgeInsets.only(top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Question ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  CircularCountDownTimer(
                    duration: 16,
                    initialDuration: 0,
                    controller: CountDownController(),
                    width: MediaQuery.of(context).size.width / 11,
                    height: MediaQuery.of(context).size.height / 11,
                    ringColor: Colors.grey[300],
                    ringGradient: null,
                    fillColor: Colors.deepPurple,
                    fillGradient: null,
                    backgroundColor: Theme.of(context).canvasColor,
                    backgroundGradient: null,
                    strokeWidth: 10.0,
                    strokeCap: StrokeCap.round,
                    textStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textFormat: CountdownTextFormat.S,
                    isReverse: true,
                    isReverseAnimation: false,
                    isTimerTextShown: true,
                    autoStart: true,
                    onStart: () {
                      if (widget.questions.isEmpty == false &&
                          widget.state.status != QuizStatus.complete) {}
                    },
                    onComplete: () async {
                      context.read(quizControllerProvider).nextQuestion(
                          widget.questions, widget.pageController.page.toInt());
                      if (widget.pageController.page.toInt() <
                          widget.questions.length) {
                        widget.pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.linear,
                        );
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  LikeButton(
                    size: 40,
                    circleColor: CircleColor(
                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    isLiked:
                        (widget.state.selectedAnswer != question.correctAnswer),
                    animationDuration: Duration(seconds: 5),
                    likeCount: 0,
                    countBuilder: (int count, bool isLiked, String text) {
                      Widget result;
                      if (!isLiked &&
                          widget.state.status == QuizStatus.correct) {
                        result = Text(
                          (points += 10).toString(),
                          style: TextStyle(color: Colors.white),
                        );
                      } else
                        result = Text(
                          points.toString(),
                          style: TextStyle(color: Colors.white),
                        );
                      return result;
                    },
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked &&
                                widget.state.status == QuizStatus.incorrect
                            ? Colors.deepPurple
                            : !isLiked &&
                                    widget.state.status == QuizStatus.correct
                                ? Colors.red
                                : Colors.grey[200],
                        size: 40,
                      );
                    },
                  ),
                ],
              ),
              Divider(
                color: Colors.white,
                height: 32.0,
                thickness: 2.0,
                indent: 50.0,
                endIndent: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
                child: Text(
                  HtmlCharacterEntities.decode(question.question),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey[200],
                height: 32.0,
                thickness: 2.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(),
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25.0),
                      topLeft: Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: question.answers
                        .map(
                          (e) => AnswerCard(
                            answer: e,
                            isSelected: e == widget.state.selectedAnswer,
                            isCorrect: e == question.correctAnswer,
                            isDisplayingAnswer: widget.state.answered,
                            onTap: () {
                              context
                                  .read(quizControllerProvider)
                                  .submitAnswer(question, e);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class QuizError extends StatelessWidget {
  final String message;

  const QuizError({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.purple[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 20.0),
            CustomButton(
              title: 'Retry',
              onTap: () => context.refresh(quizRepositoryProvider),
              color: Colors.yellow[700],
              color2: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
