import 'package:Quipia/controllers/theme_notifier.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:pedantic/pedantic.dart';
import 'package:wiredash/wiredash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool collapse = false;
  FirebaseAuth _auth;
  bool snackBar = false;
  bool isSoundTapped;
  bool isMusicTapped;
  bool isRecieveUpdates = false;
  bool _dark;

  User user;
  bool isSignedIn = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    isMusicTapped = true;
    isSoundTapped = true;
    this.checkAuthentication();
    this.getUser();
    _auth = FirebaseAuth.instance;
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
  }

  Future<void> _signOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    try {
      await _auth.signOut();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Logout failed',
        exception: e,
      ));
    }
  }

  Future<void> _confirmSignOut(
      BuildContext context, FirebaseAuth firebaseAuth) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: 'Logout',
          content: 'Are you sure that you want to logout?',
          cancelActionText: "Cancel",
          defaultActionText: "Logout",
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context, firebaseAuth);
    }
  }

  Widget _passwordChanger(collapse) {
    final _passwordNewController = TextEditingController();
    void _changePassword(String password) {
      User user = _auth.currentUser;
      EmailAuthCredential credential =
          EmailAuthProvider.credential(email: user.email, password: password);
      user.reauthenticateWithCredential(credential);
      user.updatePassword(password).then((value) {}).catchError((error) {});
    }

    if (collapse == true) {
      return Container(
        height: 120,
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.height * 0.50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: TextField(
                  controller: _passwordNewController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.lock,
                        size: 22,
                        color: Colors.deepPurple,
                      ),
                    ),
                    hintText: "Enter New Password",
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _changePassword(_passwordNewController.text);
                _passwordNewController.clear();
                _scaffoldKey.currentState.showSnackBar(
                    new SnackBar(content: new Text("Password changed!")));
              },
              child: Container(
                margin: const EdgeInsets.all(5.0),
                height: 40.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  boxShadow: boxShadow,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appThemeState = context.read(appThemeStateNotifier);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.moon),
            onPressed: () {
              setState(() {
                if (_dark == false) {
                  appThemeState.setDarkTheme();
                  _dark = true;
                } else {
                  appThemeState.setLightTheme();
                  _dark = false;
                }
              });
            },
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.deepPurple,
                  child: ListTile(
                    onTap: () {
                      //open edit profile
                    },
                    title: Text(
                      _auth.currentUser.email.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKaiKiPcLJj7ufrj6M2KaPwyCT4lDSFA5oog&usqp=CAU'),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.lock_outline,
                          color: Colors.deepPurple,
                        ),
                        title: Text("Change Password"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          if (collapse == true) {
                            setState(() {
                              collapse = false;
                            });
                            collapse = false;
                          } else {
                            setState(() {
                              collapse = true;
                            });
                          }
                        },
                      ),
                      _passwordChanger(collapse),
                      _buildDivider(),
                      ListTile(
                        leading: (isMusicTapped == true)
                            ? Icon(
                                FontAwesomeIcons.music,
                                color: Colors.deepPurple,
                              )
                            : Icon(Icons.music_off_outlined,
                                color: Colors.deepPurple),
                        title: Text("Music"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          setState(() {
                            isMusicTapped = !isMusicTapped;
                          });
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: (isSoundTapped == true)
                            ? Icon(
                                Icons.volume_up,
                                color: Colors.deepPurple,
                              )
                            : Icon(
                                Icons.volume_mute,
                                color: Colors.deepPurple,
                              ),
                        title: Text("Sound"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          setState(() {
                            isSoundTapped = !isSoundTapped;
                          });
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.comment,
                          color: Colors.deepPurple,
                        ),
                        title: Text("Provide Feedback"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Wiredash.of(context).show();
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.deepPurple,
                        ),
                        title: Text("Log Out"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => _confirmSignOut(context, _auth),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Notification Settings",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SwitchListTile(
                  activeColor: Colors.purple,
                  contentPadding: const EdgeInsets.all(0),
                  value: isRecieveUpdates,
                  title: Text("Received App  Updates"),
                  onChanged: (val) {
                    setState(() {
                      isRecieveUpdates = val;
                    });
                  },
                ),
                const SizedBox(height: 60.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
