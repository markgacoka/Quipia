import 'dart:ui';

import 'package:Quipia/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:Quipia/screens/auth/create_account.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Loginscreen extends StatelessWidget {
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
                      'Welcome Back',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
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
                  height: 65,
                ),
                TextInputField(
                  icon: FontAwesomeIcons.envelope,
                  hint: 'Email',
                  inputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  obscure: false,
                ),
                TextInputField(
                  icon: FontAwesomeIcons.lock,
                  hint: 'Password',
                  inputType: TextInputType.visiblePassword,
                  inputAction: TextInputAction.done,
                  obscure: true,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
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
                      FaIcon(
                        FontAwesomeIcons.facebook,
                        size: 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FaIcon(
                        FontAwesomeIcons.google,
                        size: 30,
                        color: Colors.white,
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
