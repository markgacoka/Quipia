import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/controllers/quiz/quiz_state.dart';
import 'package:Quipia/models/question_model.dart';
import 'package:Quipia/controllers/quiz/quiz_controller.dart';
import 'package:Quipia/repositories/quiz/quiz_repository.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:Quipia/screens/screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizResults extends StatefulWidget {
  final QuizState state;
  final List<Question> questions;

  const QuizResults({
    Key key,
    @required this.state,
    @required this.questions,
  }) : super(key: key);
  @override
  _QuizResultsState createState() => _QuizResultsState();
}

class _QuizResultsState extends State<QuizResults> {
  ConfettiController _controller;
  int points;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>["FC8FD96BEBE58E7A251FC4FE3D077FD5"],
  );
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('points');
  final String userUID = FirebaseAuth.instance.currentUser.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  InterstitialAd _interstitialAd;
  AudioPlayer audioPlayer = AudioPlayer();
  String rewardUrl =
      "https://assets.mixkit.co/sfx/preview/mixkit-bonus-earned-in-video-game-2058.mp3";
  String endLevelUrl =
      "https://assets.mixkit.co/sfx/preview/mixkit-extra-bonus-in-a-video-game-2045.mp3";
  int _pointsForConfetti;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = new ConfettiController(
        duration: new Duration(seconds: 10),
      );
    });
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-8323754226268458~7511554081');
    _interstitialAd = createInterstitialAd()..load();
    _interstitialAd?.show();
    RewardedVideoAd.instance.load(
        adUnitId: "ca-app-pub-8323754226268458/6569991592",
        targetingInfo: targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print('Rewarded event: $event');
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {});
      }
    };
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        targetingInfo: targetingInfo,
        adUnitId: "ca-app-pub-8323754226268458/1781257828",
        listener: (MobileAdEvent event) {
          print('interstitial event: $event');
        });
  }

  Future _addData(int points) async {
    Future<int> currPoints = _getPointsDB();
    return await collectionReference.doc(userUID).set({
      'name': _auth.currentUser.displayName,
      "points": (points + await currPoints),
    });
  }

  Future _addReward(int reward) async {
    Future<int> currPointsReward = _getPointsDB();
    return await collectionReference.doc(userUID).set({
      'name': _auth.currentUser.displayName,
      "points": (reward + await currPointsReward),
    });
  }

  Future<int> _getPointsDB() async {
    int currPoints;
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
    points = widget.state.correct.length * 10;
    const curveHeight = 20.0;
    _addData(points);
    setState(() {
      _pointsForConfetti = widget.state.correct.length;
      if (_pointsForConfetti > 4) {
        _controller.play();
      }
    });

    return ProviderScope(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstOver),
            image: AssetImage(
              'assets/images/thumbnails/background_results.jpg',
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              centerTitle: true,
              toolbarHeight: 80,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text("Results",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey[300],
                    )),
              ),
              shape: const MyShapeBorder(curveHeight),
            ),
            SizedBox(height: 100),
            Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    child: ResultsTile(
                      title: "Score",
                      subtitle: "$points points",
                      icon: IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.white),
                        onPressed: null,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await RewardedVideoAd.instance.show();
                      _addReward(10);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                      context.refresh(quizRepositoryProvider);
                      context.read(quizControllerProvider).reset();
                    },
                    child: Container(
                      child: ResultsTile(
                        title: "Watch Ad",
                        subtitle: "+10 points",
                        icon: IconButton(
                            icon: Icon(Icons.play_circle_fill,
                                color: Colors.white),
                            onPressed: null),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.10,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                '${widget.state.correct.length} / ${widget.questions.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              'CORRECT',
              style: TextStyle(
                color: (widget.state.correct.length > 4)
                    ? Colors.green[200]
                    : Colors.pink[300],
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            (widget.state.correct.length > 7)
                ? Text(
                    'GENIUS LEVEL',
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                : (widget.state.correct.length < 4)
                    ? Text(
                        'AT LEAST YOU TRIED',
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        'NICE WORK!',
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
            const SizedBox(height: 40.0),
            CustomButton(
              title: 'Play another quiz',
              onTap: () {
                // _bannerAd?.dispose();
                // _bannerAd = null;
                context.refresh(quizRepositoryProvider);
                context.read(quizControllerProvider).reset();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(),
                  ),
                );
              },
              color: Colors.deepPurple,
              color2: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }
}
