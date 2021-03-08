import 'package:Quipia/screens/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'screens.dart';
import 'package:Quipia/widgets/fancy_button.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var list = [10, 11, 12, 13, 14, 15, 16, 29, 31, 32];
  int noOfQuestions = 10;
  final InAppReview inAppReview = InAppReview.instance;
  int totalPoints;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _nativeAdController = NativeAdmobController();
  String currPointsHome;

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 3,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.application.Quipia',
  );

  _checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
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
  void initState() {
    super.initState();
    _checkAuthentication();
    setState(() {
      _getPointsDB().then((val) => setState(() {
            currPointsHome = val;
          }));
    });

    rateMyApp.init().then(
      (_) {
        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showStarRateDialog(
            context,
            title: 'Enjoying Quizzier?',
            message: 'A rating can go a long way...',
            actionsBuilder: (context, stars) {
              return [
                FlatButton(
                  child: Text('OK'),
                  onPressed: () async {
                    if (stars != null) {
                      await rateMyApp
                          .callEvent(RateMyAppEventType.rateButtonPressed);
                      Navigator.pop<RateMyAppDialogButton>(
                          context, RateMyAppDialogButton.rate);
                      if (stars < 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingsPage(),
                          ),
                        );
                      } else {
                        await rateMyApp
                            .callEvent(RateMyAppEventType.rateButtonPressed);
                        Navigator.pop<RateMyAppDialogButton>(
                            context, RateMyAppDialogButton.rate);
                        if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                        }
                      }
                    }
                  },
                ),
              ];
            },
            ignoreNativeDialog: false,
            dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions: StarRatingOptions(),
            onDismissed: () =>
                rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const curveHeight = 70.0;
    Random random = new Random();
    int _randomNumber = random.nextInt(100);

    return WillPopScope(
      onWillPop: () async {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  AppBar(
                    centerTitle: true,
                    toolbarHeight: 80,
                    automaticallyImplyLeading: false,
                    title: Text("Quizzier",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey[300],
                        )),
                    shape: const MyShapeBorder(curveHeight),
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.grey[300],
                        ),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: IconButton(
                        icon: Icon(
                          Icons.person,
                          color: Colors.yellow,
                        ),
                        iconSize: 35,
                        onPressed: null),
                  ),
                  Container(
                    child: Text(
                      _auth.currentUser.displayName ?? "loading...",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                      child: IconButton(
                          icon: Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          iconSize: 35,
                          onPressed: null)),
                  Container(
                    child: Text(
                      currPointsHome ?? 'loading...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              FancyButton(
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/trophy.svg",
                        width: 20, height: 20),
                    SizedBox(width: 20),
                    Text(
                      "Leaderboard",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Gameplay',
                      ),
                    ),
                  ],
                ),
                size: 25,
                color: Colors.deepPurple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Leaderboard()),
                  );
                },
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CategoryTile(
                            title: "General Knowledge",
                            imagePath:
                                "assets/images/thumbnails/general_knowledge.jpg",
                            description: "About, well, everything...",
                            id: 9,
                            noOfQuestions: noOfQuestions),
                      ),
                      Expanded(
                        child: CategoryTile(
                            title: "Science",
                            imagePath: "assets/images/thumbnails/science.jpeg",
                            description: "Science and Nature",
                            id: 17,
                            noOfQuestions: noOfQuestions),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CategoryTile(
                            title: "Art",
                            imagePath: "assets/images/thumbnails/art.jpeg",
                            description: "Painters, periods and art names",
                            id: 25,
                            noOfQuestions: noOfQuestions),
                      ),
                      Expanded(
                        child: CategoryTile(
                            title: "Entertainment",
                            imagePath:
                                "assets/images/thumbnails/entertainment.jpg",
                            description: "Culture and entertaining facts",
                            id: randomChoice(list),
                            noOfQuestions: noOfQuestions),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CategoryTile(
                            title: "Sports",
                            imagePath: "assets/images/thumbnails/sports.jpeg",
                            description: "Ball Games and Athletics",
                            id: 21,
                            noOfQuestions: noOfQuestions),
                      ),
                      Expanded(
                        child: CategoryTile(
                            title: "Technology",
                            imagePath:
                                "assets/images/thumbnails/technology.jpg",
                            description: "Computers, innovation and AI",
                            id: 18,
                            noOfQuestions: noOfQuestions),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CategoryTile(
                            title: "Politics",
                            imagePath: "assets/images/thumbnails/politics.jpg",
                            description: "Global Political Topics",
                            id: 24,
                            noOfQuestions: noOfQuestions),
                      ),
                      Expanded(
                        child: CategoryTile(
                            title: "Celebrities",
                            imagePath:
                                "assets/images/thumbnails/celebrities.jpeg",
                            description: "Famous People Dead and Alive",
                            id: 26,
                            noOfQuestions: noOfQuestions),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CategoryTile(
                            title: "Animals",
                            imagePath: "assets/images/thumbnails/animals.jpg",
                            description: "The Fauna part of Nature",
                            id: 27,
                            noOfQuestions: noOfQuestions),
                      ),
                      Expanded(
                        child: CategoryTile(
                            title: "Geography",
                            imagePath: "assets/images/thumbnails/geography.jpg",
                            description:
                                "Geographical structures all around the world",
                            id: 22,
                            noOfQuestions: noOfQuestions),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CategoryTile(
                            title: "History",
                            imagePath: "assets/images/thumbnails/history.jpeg",
                            description:
                                "The past inventions, civilzations and people",
                            id: 23,
                            noOfQuestions: noOfQuestions),
                      ),
                      Expanded(
                        child: CategoryTile(
                            title: "Vehicles",
                            imagePath: "assets/images/thumbnails/vehicles.jpg",
                            description: "Everything automobile",
                            id: 28,
                            noOfQuestions: noOfQuestions),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  (_randomNumber > 50)
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: NativeAdmob(
                            adUnitID: "ca-app-pub-8323754226268458/9659747843",
                            controller: _nativeAdController,
                            type: NativeAdmobType.full,
                            loading: Container(
                              color: Colors.grey,
                              width: MediaQuery.of(context).size.width,
                              height: double.infinity,
                              child: Center(child: Text("AD")),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nativeAdController.dispose();
    super.dispose();
  }
}
