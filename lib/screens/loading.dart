import 'package:flutter/material.dart';
import 'package:jangle_app/configs.dart';
import 'package:jangle_app/locator.dart';
import 'package:jangle_app/services/httpRequests.dart';
import 'package:jangle_app/store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  checkIfAlreadyLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    bool isLoggedIn = pref.getBool(Config.loggedIn) ?? false;
    if (isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Already logged in!\nLoading...'),
      ));
      String authToken = pref.getString(Config.authToken)!;
      String userId = pref.getString(Config.userId)!;
      locator.get<HttpRequests>().setAuthToken(authToken);
      locator.get<HttpRequests>().setUserId(userId);

      await locator.get<HttpRequests>().getUserById(userId).then((value) {
        context.read<Store>().setCurrentUser(value['user']);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('[500] Internal server error\nPlease restart the app..'),
        ));
      });

      await locator.get<HttpRequests>().getAllUsers().then((value) {
        final users = value['users'].cast<Map<String, dynamic>>();
        context.read<Store>().setUsers(users);
        Navigator.pushReplacementNamed(context, '/home');
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('[500] Internal server error\nPlease restart the app..'),
        ));
      });
    } else {
      Navigator.pushReplacementNamed(context, '/signIn');
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLoggedIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
