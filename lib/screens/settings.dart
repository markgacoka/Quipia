import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    const curveHeight = 70.0;
    const size = 15.0;
    const margin = 35.0;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.dstATop),
            image: new NetworkImage(
              'https://cdn.pixabay.com/photo/2012/04/13/01/23/moon-31665__340.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      title: Text("Settings",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey[300],
                          )),
                      shape: const MyShapeBorder(curveHeight),
                    ),
                  ],
                ),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(
                      () {
                        isSwitched = value;
                      },
                    );
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 70),
                ),
                SettingsButton(
                  size: size,
                  onPressed: () {},
                  color: Colors.deepPurple,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.music_note,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          onPressed: null),
                      Text(
                        "Music",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: margin),
                SettingsButton(
                  size: size,
                  onPressed: () {},
                  color: Colors.deepPurple,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.speaker,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          onPressed: null),
                      Text(
                        "Sound",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: margin),
                SettingsButton(
                  size: size,
                  onPressed: () {},
                  color: Colors.deepPurple,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.gamepad,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          onPressed: null),
                      Text(
                        "Difficulty",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: margin),
                SettingsButton(
                  size: size,
                  onPressed: () {},
                  color: Colors.deepPurple,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.warning,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          onPressed: null),
                      Text(
                        "Report",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: margin),
                SettingsButton(
                  size: size,
                  color: Colors.deepPurple,
                  onPressed: () {},
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          onPressed: null),
                      Text(
                        "Log Out",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
