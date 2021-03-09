import 'package:Quipia/providers/auth_provider.dart';
import 'package:Quipia/screens/screens.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  String _email;

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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
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
                          'Forgot Password',
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
                          "We'll send you an email with a login link",
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
                      inputAction: TextInputAction.done,
                      obscure: false,
                      controller: _emailController,
                      onChanged: (text) {
                        setState(
                          () {
                            _email = text;
                            if (_emailController.text.isEmpty) {
                              _fieldValidate(context);
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: ButtonTheme(
                        buttonColor: Colors.white,
                        minWidth: MediaQuery.of(context).size.width,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            _auth.resetPassword(_email).then((value) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => VerifyScreen()));
                            }).catchError((e) => print(e));
                          },
                          child: Text(
                            'Send Password',
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 22),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                      ),
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
