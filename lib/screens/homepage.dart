import 'package:Quipia/screens/leaderboard.dart';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'screens.dart';
import 'package:Quipia/widgets/fancy_button.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:in_app_review/in_app_review.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.points = 0}) : super(key: key);

  final String title;
  final int points;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var list = [10, 11, 12, 13, 14, 15, 16, 29, 31, 32];
  int noOfQuestions = 10;
  final InAppReview inAppReview = InAppReview.instance;
  int totalPoints;

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 3,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.application.Quizzier',
  );

  @override
  void initState() {
    super.initState();
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
                            builder: (_) => ContactUs(),
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
                    "Mark",
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
                    widget.points.toString(),
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
                          imageUrl:
                              "https://cdn.pixabay.com/photo/2018/05/08/08/50/artificial-intelligence-3382521__340.jpg",
                          description: "About, well, everything...",
                          id: 9,
                          noOfQuestions: noOfQuestions),
                    ),
                    Expanded(
                      child: CategoryTile(
                          title: "Science",
                          imageUrl:
                              "https://images.pexels.com/photos/355938/pexels-photo-355938.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
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
                          imageUrl:
                              "https://images.pexels.com/photos/1194420/pexels-photo-1194420.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                          description: "Painters, periods and art names",
                          id: 25,
                          noOfQuestions: noOfQuestions),
                    ),
                    Expanded(
                      child: CategoryTile(
                          title: "Entertainment",
                          imageUrl:
                              "https://cdn.pixabay.com/photo/2015/07/30/17/24/audience-868074_960_720.jpg",
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
                          imageUrl:
                              "https://images.pexels.com/photos/1127120/pexels-photo-1127120.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                          description: "Ball Games and Athletics",
                          id: 21,
                          noOfQuestions: noOfQuestions),
                    ),
                    Expanded(
                      child: CategoryTile(
                          title: "Technology",
                          imageUrl:
                              "https://cdn.pixabay.com/photo/2014/09/20/13/52/board-453758__340.jpg",
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
                          imageUrl:
                              "https://cdn.pixabay.com/photo/2017/08/03/11/05/people-2575608__340.jpg",
                          description: "Global Political Topics",
                          id: 24,
                          noOfQuestions: noOfQuestions),
                    ),
                    Expanded(
                      child: CategoryTile(
                          title: "Celebrities",
                          imageUrl:
                              "https://images.pexels.com/photos/4262423/pexels-photo-4262423.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
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
                          imageUrl:
                              "https://cdn.pixabay.com/photo/2017/05/31/18/38/sea-2361247__340.jpg",
                          description: "The Fauna part of Nature",
                          id: 27,
                          noOfQuestions: noOfQuestions),
                    ),
                    Expanded(
                      child: CategoryTile(
                          title: "Geography",
                          imageUrl:
                              "https://cdn.pixabay.com/photo/2018/06/18/23/03/europe-3483539__340.jpg",
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
                          imageUrl:
                              "https://images.pexels.com/photos/2402926/pexels-photo-2402926.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                          description:
                              "The past inventions, civilzations and people",
                          id: 23,
                          noOfQuestions: noOfQuestions),
                    ),
                    Expanded(
                      child: CategoryTile(
                          title: "Vehicles",
                          imageUrl:
                              "https://cdn.pixabay.com/photo/2016/03/11/02/08/speedometer-1249610__340.jpg",
                          description: "Everything automobile",
                          id: 28,
                          noOfQuestions: noOfQuestions),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
