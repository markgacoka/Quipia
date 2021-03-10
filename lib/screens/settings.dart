import 'package:Quipia/controllers/theme_notifier.dart';
import 'package:Quipia/providers/auth_provider.dart';
import 'package:Quipia/providers/login_providers.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wiredash/wiredash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with ChangeNotifier {
  bool collapse = false;
  bool snackBar = false;
  bool isSoundTapped;
  bool isRecieveUpdates = false;
  bool _dark;
  final _passwordNewController = TextEditingController();
  String text =
      'https://play.google.com/store/apps/details?id=com.example.Quipia';
  String subject = 'Share the Trivia App!';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    isSoundTapped = true;
  }

  @override
  void dispose() {
    _passwordNewController?.dispose();
    super.dispose();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _fieldValidate(BuildContext context) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: 'Error!',
          content: 'Field cannot be empty.',
          defaultActionText: "Ok",
        ) ??
        false;
    if (didRequestSignOut == true) {}
  }

  Future<void> _confirmSignOut(BuildContext context, auth) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: 'Logout',
          content: 'Are you sure that you want to logout?',
          cancelActionText: "Cancel",
          defaultActionText: "Logout",
        ) ??
        false;
    if (didRequestSignOut == true) {
      await auth.signout();
    }
  }

  Widget _passwordChanger(context, auth, pass, collapse) {
    void updatePassword(BuildContext context, String pass) {
      context.read(passwordProvider).state = pass;
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
                  onChanged: (text) {
                    updatePassword(context, text);
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_passwordNewController.text.isEmpty) {
                  _fieldValidate(context);
                }
                auth.changePassword(pass);
                _passwordNewController.clear();
                _scaffoldKey.currentState.showSnackBar(
                    new SnackBar(content: new Text("Password changed!")));
                auth.signout();
                Navigator.of(context).pop();
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
    double height = MediaQuery.of(context).size.height * 0.12;
    return Consumer(
      builder: (context, watch, child) {
        final appThemeState = context.read(appThemeStateNotifier);
        final pass = watch(passwordProvider).state;
        final _auth = watch(authServicesProvider);
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
                icon: Icon(
                  FontAwesomeIcons.shareAlt,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(text,
                      subject: subject,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
              ),
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
                          _auth.displayName(),
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
                          _passwordChanger(context, _auth, pass, collapse),
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
                              FontAwesomeIcons.moon,
                              color: Colors.deepPurple,
                            ),
                            title: Text("Dark mode"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
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
                              onTap: () {
                                Navigator.of(context).pop();
                                _confirmSignOut(context, _auth);
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "About",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    _buildDivider(),
                    ListTile(
                      title: Text("Rate Us"),
                      subtitle: Text("We would appreciate your feedback!"),
                      leading: Icon(
                        Icons.star,
                        color: Colors.deepPurple,
                      ),
                      onTap: () async {
                        _launchURL(text);
                      },
                    ),
                    _buildDivider(),
                    SizedBox(height: height),
                    ListTile(
                      title: Text("Version"),
                      subtitle: Text("Version 1.0. Made with love in 2021."),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
