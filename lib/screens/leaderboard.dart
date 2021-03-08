import 'package:Quipia/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String currPointsLeaderboard;

  @override
  void initState() {
    super.initState();
    setState(() {
      _getPointsDB().then((val) => setState(() {
            currPointsLeaderboard = val;
          }));
    });
    getData();
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

  Future<List<DocumentSnapshot>> getData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("points")
        .orderBy("points", descending: true)
        .limit(20)
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.deepPurple,
                // decoration: BoxDecoration(
                //   color: const Color(0xff7c94b6),
                //   image: DecorationImage(
                //     fit: BoxFit.cover,
                //     colorFilter: ColorFilter.mode(
                //         Colors.black.withOpacity(0.1), BlendMode.dstATop),
                //     image: NetworkImage(
                //       'https://cdn.pixabay.com/photo/2017/08/04/10/36/background-2579719__340.jpg',
                //     ),
                //   ),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 80)),
                            Padding(
                              padding: EdgeInsets.only(right: 60),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey[300],
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 80),
                              child: Text("Leaderboard",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.green[200],
                                      fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.green,
                                ),
                                iconSize: 40,
                                onPressed: null),
                            Text(_auth.currentUser.displayName ?? "loading...",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800)),
                            IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: Colors.orange[500],
                                ),
                                iconSize: 30,
                                onPressed: null),
                            Text(
                              currPointsLeaderboard ?? 'loading...',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKaiKiPcLJj7ufrj6M2KaPwyCT4lDSFA5oog&usqp=CAU"),
                    ),
                    CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKaiKiPcLJj7ufrj6M2KaPwyCT4lDSFA5oog&usqp=CAU")),
                    CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKaiKiPcLJj7ufrj6M2KaPwyCT4lDSFA5oog&usqp=CAU")),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 15,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 50,
                    elevation: 0,
                    backgroundColor: Color(0xff232d37),
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: <Widget>[
                        Tab(
                          text: 'Leaderboard',
                        ),
                        Tab(
                          text: 'Statistics',
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      FutureBuilder(
                          future: getData(),
                          builder: (_,
                              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (_, index) {
                                  return ListTile(
                                    tileColor:
                                        (snapshot.data[index].data()['name'] !=
                                                _auth.currentUser.displayName)
                                            ? Color(0xff232d37)
                                            : Colors.grey[800],
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKaiKiPcLJj7ufrj6M2KaPwyCT4lDSFA5oog&usqp=CAU'),
                                    ),
                                    trailing: Text(
                                      '${snapshot.data[index].data()['points']} points',
                                      style: TextStyle(
                                          color: Color(0xff02d39a),
                                          fontSize: 15),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          snapshot.data[index].data()['name'],
                                          style: TextStyle(
                                              color: Colors.grey[200]),
                                        ),
                                        SizedBox(width: 100),
                                        // Text("10")
                                      ],
                                    ),
                                    // subtitle: Text('United States'),
                                  );
                                },
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Color(0xff232d37),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ranking by percentile",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              child: LineChartPage(),
                              constraints: BoxConstraints.expand(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
