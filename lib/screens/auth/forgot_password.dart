import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPassword extends StatelessWidget {
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
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
