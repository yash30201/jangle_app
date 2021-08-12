import 'package:flutter/material.dart';
import 'package:jangle_app/locator.dart';
import 'package:jangle_app/screens/home.dart';
import 'package:jangle_app/screens/loading.dart';
import 'package:jangle_app/screens/search.dart';
import 'package:jangle_app/screens/signin.dart';
import 'package:jangle_app/screens/signup.dart';
import 'package:jangle_app/store.dart';
import 'package:jangle_app/styles.dart' as styles;
import 'package:provider/provider.dart';

void main() {
  setup();
  runApp(ChangeNotifierProvider(
    create: (context) => Store(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jangle',
      theme: styles.themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => Loading(),
        '/signIn': (context) => SignIn(),
        '/signUp': (context) => SignUp(),
        '/home': (context) => Home(),
        '/search': (context) => SearchScreen(),
      },
    );
  }
}
