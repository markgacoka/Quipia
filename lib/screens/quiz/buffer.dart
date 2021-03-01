import 'package:Quipia/controllers/quiz/quiz_controller.dart';
import 'package:Quipia/controllers/quiz/quiz_state.dart';
import 'package:Quipia/models/question_model.dart';
import 'package:Quipia/repositories/quiz/quiz_repository.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:confetti/confetti.dart';
import 'package:Quipia/screens/screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:firebase_admob/firebase_admob.dart';
// import 'package:flutter_native_admob/native_admob_controller.dart';

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
  ConfettiController _controllerCenter;
  int points;
  // BannerAd _bannerAd;
  // InterstitialAd _interstitialAd;
  // final _nativeAdController = NativeAdmobController();
  // static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

  // BannerAd createBannerAdd() {
  //   return BannerAd(
  //       targetingInfo: targetingInfo,
  //       adUnitId: BannerAd.testAdUnitId,
  //       size: AdSize.smartBanner,
  //       listener: (MobileAdEvent event) {
  //         print('Bnner Event: $event');
  //       });
  // }

  // InterstitialAd createInterstitialAd() {
  //   return InterstitialAd(
  //       targetingInfo: targetingInfo,
  //       adUnitId: InterstitialAd.testAdUnitId,
  //       listener: (MobileAdEvent event) {
  //         print('interstitial event: $event');
  //       });
  // }

  @override
  void initState() {
    super.initState();
    // FirebaseAdMob.instance
    //     .initialize(appId: 'ca-app-pub-8323754226268458~7511554081');
    // _interstitialAd = createInterstitialAd()..load();
    // _bannerAd = createBannerAdd()..load();
    // RewardedVideoAd.instance.load(
    //     adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
    // RewardedVideoAd.instance.listener =
    //     (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
    //   print('Rewarded event: $event');
    //   if (event == RewardedVideoAdEvent.rewarded) {
    //     setState(() {
    //       points += rewardAmount;
    //     });
    //   }
    // };
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    // _bannerAd?.dispose();
    // _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int points = widget.state.correct.length * 10;
    const curveHeight = 20.0;

    // Timer(Duration(seconds: 10), () {
    //   _bannerAd?.show();
    // });

    return ProviderScope(
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.deepPurple[700],
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: new NetworkImage(
              'https://cdn.pixabay.com/photo/2016/10/20/18/35/earth-1756274_960_720.jpg',
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
                GestureDetector(
                  onTap: () {
                    // _bannerAd?.dispose();
                    // _bannerAd = null;
                    // await RewardedVideoAd.instance.show();
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Expanded(
                    child: Container(
                      child: ResultsTile(
                        title: "Watch Ad",
                        subtitle: "+10 points",
                        icon: IconButton(
                          icon:
                              Icon(Icons.play_circle_fill, color: Colors.white),
                          onPressed: () {
                            // _bannerAd?.dispose();
                            // _bannerAd = null;
                            // _interstitialAd?.show();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage()));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            (widget.state.correct.length > 7)
                ? ConfettiWidget(
                    confettiController: _controllerCenter,
                    blastDirectionality: BlastDirectionality.explosive,
                    particleDrag: 0.05,
                    emissionFrequency: 0.05,
                    numberOfParticles: 20,
                    gravity: 0.05,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                  )
                : SizedBox.shrink(),
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
}
