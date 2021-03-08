import 'package:flutter/material.dart';
import 'package:Quipia/screens/screens.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wiredash/wiredash.dart';
import 'controllers/theme_notifier.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  final String projectId = 'quipia-4emgypq';
  final String secret = 'yodepz2onc8c66kfxmgzh4tyn1egusie0vl48frmw8hpqc41';
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final appThemeState = useProvider(appThemeStateNotifier);
    return Wiredash(
      navigatorKey: navigatorKey,
      secret: secret,
      projectId: projectId,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            appThemeState.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
        title: 'Quizzier',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          '/home': (BuildContext context) => HomePage(),
          '/signin': (BuildContext context) => Loginscreen(),
          '/signup': (BuildContext context) => SignUpScreen(),
        },
      ),
    );
  }
}
