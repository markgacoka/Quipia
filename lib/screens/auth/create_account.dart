import 'package:Quipia/providers/auth_provider.dart';
import 'package:Quipia/providers/login_providers.dart';
import 'package:Quipia/screens/auth/verify%20screen.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void updateName(BuildContext context, String name) {
    context.read(nameProvider).state = name;
  }

  void updateEmail(BuildContext context, String email) {
    context.read(emailProvider).state = email;
  }

  void updatePassword(BuildContext context, String pass) {
    context.read(passwordProvider).state = pass;
  }

  Future<void> _validateFieldInput(BuildContext context) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: 'Error!',
          content: 'Field cannot be empty.',
          defaultActionText: "Ok",
        ) ??
        false;
    if (didRequestSignOut == true) {}
  }

  Future<void> _validatePasswordInput(BuildContext context) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: 'Error!',
          content: 'Passwords do not match.',
          defaultActionText: "Ok",
        ) ??
        false;
    if (didRequestSignOut == true) {}
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
    return Consumer(
      builder: (context, watch, child) {
        final name = watch(nameProvider).state;
        final email = watch(emailProvider).state;
        final password = watch(passwordProvider).state;
        final _auth = watch(authServicesProvider);
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
                              updateName(context, text);
                            },
                            controller: _nameController,
                          ),
                          TextInputField(
                            icon: FontAwesomeIcons.envelope,
                            hint: 'Email',
                            inputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.next,
                            obscure: false,
                            onChanged: (text) {
                              updateEmail(context, text);
                            },
                            controller: _emailController,
                          ),
                          TextInputField(
                            icon: FontAwesomeIcons.lock,
                            hint: 'Password',
                            inputAction: TextInputAction.next,
                            obscure: true,
                            onChanged: (text) {},
                            controller: _password1Controller,
                          ),
                          TextInputField(
                            icon: FontAwesomeIcons.lock,
                            hint: 'Confirm Password',
                            inputAction: TextInputAction.done,
                            obscure: true,
                            onChanged: (text) {
                              updatePassword(context, text);
                            },
                            controller: _password2Controller,
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
                              if (_password1Controller.text !=
                                  _password2Controller.text) {
                                _validatePasswordInput(context);
                                _password1Controller.clear();
                                _password2Controller.clear();
                              } else if (_password1Controller.text.isEmpty ||
                                  _password2Controller.text.isEmpty ||
                                  _emailController.text.isEmpty ||
                                  _nameController.text.isEmpty) {
                                _validateFieldInput(context);
                              } else {
                                _auth.signUp(
                                    name: name,
                                    email: email,
                                    password: password);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => VerifyScreen()));
                              }
                            },
                            child: Text(
                              'Create',
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 22),
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
      },
    );
  }
}
