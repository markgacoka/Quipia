import 'package:Quipia/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.1), BlendMode.dstATop),
                    image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2017/08/04/10/36/background-2579719__340.jpg',
                    ),
                  ),
                ),
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
                                  color: Colors.pink,
                                ),
                                iconSize: 40,
                                onPressed: null),
                            Text("Mark",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800)),
                            IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                ),
                                iconSize: 30,
                                onPressed: null),
                            Text(
                              "250",
                              style: TextStyle(
                                  color: Colors.black,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/11/26/00/14/woman-1063100__340.jpg"),
                    ),
                    CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/09/02/13/24/girl-919048__340.jpg")),
                    CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            "https://cdn.pixabay.com/photo/2016/11/29/13/14/attractive-1869761__340.jpg")),
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
                    backgroundColor: Colors.grey[500],
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
                      ListView.builder(
                          itemCount: 20,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: CircleAvatar(),
                              trailing: Text(
                                "200",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 15),
                              ),
                              title: Row(
                                children: [
                                  Text("Person $index"),
                                  SizedBox(width: 100),
                                  Text("10")
                                ],
                              ),
                              subtitle: Text('United States'),
                            );
                          }),
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Average number of correct answers",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            flex: 10,
                            child: Container(
                              width: 350,
                              child: LineCharts(),
                            ),
                          ),
                          SizedBox(height: 20),
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
