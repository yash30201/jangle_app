import 'package:flutter/material.dart';
import 'package:jangle_app/locator.dart';
import 'package:jangle_app/services/httpRequests.dart';
import 'package:jangle_app/styles.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberEditingController =
      TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController firstNameEditingController =
      TextEditingController();
  final TextEditingController lastNameEditingController =
      TextEditingController();

  bool isProcessing = false;

  signUp() {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        setState(() => isProcessing = true);
        locator
            .get<HttpRequests>()
            .signup(
                firstNameEditingController.text,
                lastNameEditingController.text,
                phoneNumberEditingController.text,
                passwordEditingController.text)
            .then((value) async {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Success! Please login...'),
          ));
          Navigator.pushReplacementNamed(context, '/signIn');
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error['error']),
          ));
          phoneNumberEditingController.clear();
          passwordEditingController.clear();
          firstNameEditingController.clear();
          lastNameEditingController.clear();
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
    firstNameEditingController.dispose();
    lastNameEditingController.dispose();
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
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 100),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          obscureText: false,
                          controller: firstNameEditingController,
                          decoration: textFieldInputDecoration('First name'),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value != null &&
                                RegExp(r"^([a-zA-z]{4,32})$").hasMatch(value))
                              return null;
                            else
                              return "Should be non-empty alphabetic!";
                          },
                        ),
                        TextFormField(
                          obscureText: false,
                          controller: lastNameEditingController,
                          decoration: textFieldInputDecoration('Last name'),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value != null &&
                                RegExp(r"^([a-zA-z]{4,32})$").hasMatch(value))
                              return null;
                            else
                              return "Should be non-empty alphabetic!";
                          },
                        ),
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
                          decoration: textFieldInputDecoration('Password'),
                          textInputAction: TextInputAction.done,
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                        child: GestureDetector(
                          onTap: () {
                            signUp();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "SignUp",
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
                            "Already have an account? ",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.popAndPushNamed(context, '/signIn');
                            },
                            child: Text(
                              "Sign in now",
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
        ),
      );
  }
}
