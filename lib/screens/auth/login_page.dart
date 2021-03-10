import 'dart:ui';

import 'package:Quipia/providers/auth_provider.dart';
import 'package:Quipia/providers/login_providers.dart';
import 'package:Quipia/screens/screens.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:Quipia/screens/auth/create_account.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailText = TextEditingController();
  final _passwordText = TextEditingController();
  String message;

  @override
  void dispose() {
    _emailText?.dispose();
    _passwordText?.dispose();
    super.dispose();
  }

  void updateEmail(BuildContext context, String email) {
    context.read(emailProvider).state = email;
  }

  void updatePassword(BuildContext context, String pass) {
    context.read(passwordProvider).state = pass;
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

  _showVerifyEmailSentDialog(BuildContext context, user) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: 'Verify email!',
          content: 'You first have to verify your email before signing in.',
          defaultActionText: "Resend verification",
        ) ??
        false;
    if (didRequestSignOut == true) {}
  }

  Future _showWrongInput(BuildContext context) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: 'Invalid email or password!',
          content: 'You entered the wrong email or password.',
          defaultActionText: "Try again",
        ) ??
        false;
    if (didRequestSignOut == true) {}
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final email = watch(emailProvider).state;
        final pass = watch(passwordProvider).state;
        final _auth = watch(authServicesProvider);
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
                    image: AssetImage('assets/images/1.png'),
                    fit: BoxFit.cover),
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
                            controller: _emailText,
                            onChanged: (text) {
                              updateEmail(context, text);
                            },
                          ),
                          TextInputField(
                            icon: FontAwesomeIcons.lock,
                            hint: 'Password',
                            inputType: TextInputType.visiblePassword,
                            inputAction: TextInputAction.done,
                            obscure: true,
                            controller: _passwordText,
                            onChanged: (text) {
                              updatePassword(context, text);
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
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
                            onPressed: () async {
                              if (_emailText.text.isEmpty ||
                                  _passwordText.text.isEmpty) {
                                _fieldValidate(context);
                                _emailText.clear();
                                _passwordText.clear();
                              }
                              await _auth
                                  .signIn(email: email, password: pass)
                                  .then((user) {
                                if (user == null) {
                                  _emailText.clear();
                                  _passwordText.clear();
                                  return _showWrongInput(context);
                                } else {
                                  if (!(user.emailVerified)) {
                                    _emailText.clear();
                                    _passwordText.clear();
                                    user.sendEmailVerification();
                                    _auth.signout();
                                    return _showVerifyEmailSentDialog(
                                        context, user);
                                  } else {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    return HomePage();
                                  }
                                }
                              });
                            },
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 22),
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
                            onTap: () async {
                              message = await _auth.signInWithFacebook();
                              await showAlertDialog(
                                context: context,
                                title: 'Important!',
                                content: message,
                                defaultActionText: "Ok",
                              );
                            },
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
                              _auth.signInWithGoogle();
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
      },
    );
  }
}
