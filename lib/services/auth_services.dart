import 'package:Quipia/screens/auth/login_page.dart';
import 'package:Quipia/screens/screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChange => _firebaseAuth.authStateChanges();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  Map userProfile;
  Map<String, dynamic> googleProfile;

  Future<User> signIn({String email, String password}) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user.user;
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signUp({String name, String email, String password}) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user != null) {
        await FirebaseAuth.instance.currentUser
            .updateProfile(displayName: name);
        await FirebaseFirestore.instance
            .collection('points')
            .doc(user.user.uid)
            .set({'name': name, 'points': '0'});
      }
      user.user.sendEmailVerification();
      signout();
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  Future signInWithFacebook() async {
    try {
      final result = await facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final token = result.accessToken.token;
          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
          final profile = JSON.jsonDecode(graphResponse.body);
          if (profile != null) {
            UserCredential user =
                await _firebaseAuth.signInWithEmailAndPassword(
              email: profile['email'],
              password: profile['id'],
            );
            await _firebaseAuth.currentUser
                .updateProfile(displayName: profile['name']);
            await FirebaseFirestore.instance
                .collection('points')
                .doc(user.user.uid)
                .set({'name': profile['name'], 'points': '0'});
          }
          return VerifyScreen();
          break;

        case FacebookLoginStatus.cancelledByUser:
          return "Cancelled by User";
          break;
        case FacebookLoginStatus.error:
          return "Login status error!";
          break;
      }
      return "Login Successful";
    } catch (e) {
      return e.message;
    }
  }

  // Future<void> _alertVerification(
  //     BuildContext context, FirebaseAuth firebaseAuth) async {
  //   await showAlertDialog(
  //     context: context,
  //     title: 'Verify Email',
  //     content: 'You have not yet verified your email!',
  //     defaultActionText: "Ok",
  //   );
  // }

  Future<String> signInWithGoogle() async {
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        return FirebaseFirestore.instance
            .collection('points')
            .doc(firebaseUser.uid)
            .snapshots()
            .map((snap) => snap.data());
      } else {
        return {};
      }
    });
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final authResult =
          await _firebaseAuth.signInWithCredential(authCredential);
      final User user = authResult.user;
      if (user != null) {
        await FirebaseAuth.instance.currentUser
            .updateProfile(displayName: user.displayName);
        await FirebaseFirestore.instance
            .collection('points')
            .doc(user.uid)
            .set({'name': user.displayName, 'points': '0'});
      }

      return "SignIn Successful";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  String displayName() {
    return _firebaseAuth.currentUser.displayName;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return "Email sent";
  }

  User currentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> sendVerificationEmail(String email) async {
    await _firebaseAuth.currentUser.sendEmailVerification();
  }

  Future<void> signout() async {
    await _firebaseAuth.signOut();
    return Loginscreen();
  }
}
