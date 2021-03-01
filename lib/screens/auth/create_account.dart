import 'package:flutter/material.dart';
import 'package:Quipia/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatelessWidget {
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
                TextInputField(
                  icon: FontAwesomeIcons.user,
                  hint: 'Username',
                  inputType: TextInputType.name,
                  inputAction: TextInputAction.next,
                  obscure: false,
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
                  inputAction: TextInputAction.next,
                  obscure: true,
                ),
                TextInputField(
                  icon: FontAwesomeIcons.lock,
                  hint: 'Confirm Password',
                  inputAction: TextInputAction.done,
                  obscure: true,
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
                        onPressed: () {},
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
