import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Quipia/screens/screens.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String _name, _email, _password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  _signUp(email, password, name) async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (user != null) {
          await FirebaseAuth.instance.currentUser
              .updateProfile(displayName: name);
          await FirebaseFirestore.instance
              .collection('points')
              .doc(user.user.uid)
              .set({'name': _name, 'points': '0'});
        }
      } catch (e) {
        showError(e);
      }
    }
  }

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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
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
                  height: MediaQuery.of(context).size.width / 8,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Create Account',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      TextInputField(
                        icon: FontAwesomeIcons.user,
                        hint: 'Username',
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        obscure: false,
                        onChanged: (text) {
                          _name = text;
                        },
                      ),
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
                        inputAction: TextInputAction.next,
                        obscure: true,
                        onChanged: (text) {
                          _password = text;
                        },
                      ),
                      TextInputField(
                        icon: FontAwesomeIcons.lock,
                        hint: 'Confirm Password',
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
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: ButtonTheme(
                      buttonColor: Colors.white,
                      minWidth: MediaQuery.of(context).size.width,
                      height: 55,
                      child: RaisedButton(
                        onPressed: () {
                          _signUp(_email, _password, _name)
                              .then((UserCredential user) async {
                            await user.user.sendEmailVerification();
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          }).catchError((e) => print(e));
                        },
                        child: Text(
                          'Create',
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 22),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
