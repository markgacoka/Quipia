import 'package:flutter/material.dart';
import 'package:Quipia/screens/screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
        title: 'Quizzier',
        debugShowCheckedModeBanner: false,
        home: Loginscreen(),
      ),
    );
  }
}
