import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jangle_app/configs.dart';
import 'package:jangle_app/locator.dart';
import 'package:jangle_app/services/httpRequests.dart';
import 'package:jangle_app/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberEditingController =
      TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  bool isProcessing = false;

  signIn() {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        setState(() => isProcessing = true);
        locator
            .get<HttpRequests>()
            .login(phoneNumberEditingController.text,
                passwordEditingController.text)
            .then((value) async {
          final pref = await SharedPreferences.getInstance();
          pref.setBool(Config.loggedIn, true);
          pref.setString(Config.userId, value['userId']);
          pref.setString(Config.authToken, value['authToken']);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login success!'),
          ));
          Navigator.pushReplacementNamed(context, '/loading');
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error['error']),
          ));
          phoneNumberEditingController.clear();
          passwordEditingController.clear();
          setState(() {
            isProcessing = false;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    phoneNumberEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isProcessing) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: phoneNumberEditingController,
                        decoration: textFieldInputDecoration('Phone Number'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val != null && val.length == 10)
                            return null;
                          else
                            return 'Invalid phone number';
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordEditingController,
                        textInputAction: TextInputAction.done,
                        decoration: textFieldInputDecoration('Password'),
                        validator: (value) {
                          if (value != null &&
                              RegExp(r"(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})")
                                  .hasMatch(value))
                            return null;
                          else
                            return "For password -\nlength >= 8\nhave at least 1 [a-z]\nhave at least 1 [A-Z]\nhave at least 1 special char\nhave at least 1 [0-9]";
                        },
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "SignIn",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(context, '/signUp');
                          },
                          child: Text(
                            "Sign up now",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}
