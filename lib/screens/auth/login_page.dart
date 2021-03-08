import 'dart:ui';

import 'package:Quipia/screens/screens.dart';
// import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:Quipia/screens/auth/create_account.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _email, _password;

  String clientID = "1918152381665381";
  String yourRedirectUrl =
      "https://www.facebook.com/connect/login_success.html";
  String oAuthUrl = 'https://quipia-4bd97.firebaseapp.com/__/auth/handler';

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  Future<UserCredential> _signIn(email, password) async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      try {
        Future<UserCredential> _user = _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        return _user;
      } catch (e) {
        showError(e);
      }
    }
    return null;
  }

  // _signInWithFacebook() async {
  //   String result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => CustomWebView(
  //               selectedUrl:
  //                   'https://www.facebook.com/dialog/oauth?client_id=$clientID&redirect_uri=$yourRedirectUrl&response_type=token&scope=email,public_profile,',
  //             ),
  //         maintainState: true),
  //   );

  //   if (result != null) {
  //     try {
  //       final facebookAuthCred = FacebookAuthProvider.credential(result);
  //       final user =
  //           await FirebaseAuth.instance.signInWithCredential(facebookAuthCred);
  //       if (user != null) {
  //         await FirebaseAuth.instance.currentUser
  //             .updateProfile(displayName: user.user.displayName);
  //       }
  //       return user;
  //     } catch (e) {}
  //   }
  // }

  // Future<UserCredential> _signInWithFacebook() async {
  //   final result = await FacebookAuth.instance.login();
  //   final FacebookAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(result.token);
  //   final user = await FirebaseAuth.instance
  //       .signInWithCredential(facebookAuthCredential);
  //   if (user != null) {
  //     await FirebaseAuth.instance.currentUser
  //         .updateProfile(displayName: user.user.displayName);
  //   }
  //   return user;
  // }

  // Future<void> _alertVerification(
  //     BuildContext context, FirebaseAuth firebaseAuth) async {
  //   await showAlertDialog(
  //     context: context,
  //     title: 'Verify Email',
  //     content: 'You have not yet verified your email!',
  //     defaultActionText: "Ok",
  //   );
  // }

  Future<User> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final authResult = await _auth.signInWithCredential(authCredential);
      final User user = authResult.user;
      if (user != null) {
        await FirebaseAuth.instance.currentUser
            .updateProfile(displayName: user.displayName);
      }

      return user;
    } catch (e) {}
    return null;
  }

  /* Showing the error message */

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/1.png'), fit: BoxFit.cover),
            gradient: LinearGradient(
                colors: [Colors.blue[400], Colors.deepPurple],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 180,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Sign in with your account',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextInputField(
                        icon: FontAwesomeIcons.envelope,
                        hint: 'Email',
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        obscure: false,
                        onChanged: (text) {
                          _email = text;
                        },
                      ),
                      TextInputField(
                        icon: FontAwesomeIcons.lock,
                        hint: 'Password',
                        inputType: TextInputType.visiblePassword,
                        inputAction: TextInputAction.done,
                        obscure: true,
                        onChanged: (text) {
                          _password = text;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ForgotPassword()));
                      },
                      child: Container(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: ButtonTheme(
                      buttonColor: Colors.white,
                      minWidth: MediaQuery.of(context).size.width,
                      height: 55,
                      child: RaisedButton(
                        onPressed: () {
                          _signIn(_email, _password).then(
                            (UserCredential user) {
                              // if (user.user.emailVerified == true) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => HomePage()));
                              // } else {
                              //   _alertVerification(context, _auth);
                              // }
                            },
                          ).catchError((e) => print(e));
                        },
                        child: Text(
                          'Log in',
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 22),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'OR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        // onTap: () {
                        //   _signInWithFacebook().then((user) {
                        //     Navigator.push(
                        //         context,
                        //         new MaterialPageRoute(
                        //             builder: (context) => HomePage()));
                        //   }).catchError((e) => print("Error: $e"));
                        // },
                        child: FaIcon(
                          FontAwesomeIcons.facebook,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _signInWithGoogle().then((User user) {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          }).catchError((e) => print(e));
                        },
                        child: FaIcon(
                          FontAwesomeIcons.google,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't Have an Accout ?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => SignUpScreen()));
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
