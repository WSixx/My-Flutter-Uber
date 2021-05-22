import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_rider_app/main.dart';
import 'package:my_rider_app/screens/register_screen.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 55.0),
              Image(
                image: AssetImage("assets/images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 1.0),
              Text(
                'Login as Rider',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontFamily: 'Brand Bold'),
              ),
              const SizedBox(height: 1.0),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 1.0),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 22.0),
                    ElevatedButton(
                      onPressed: () {
                        if (!emailController.text.trim().contains('@') &&
                            !emailController.text.contains('.')) {
                          showSnackbar("email not valid", context);
                        } else if (passwordController.text.trim().length < 6) {
                          showSnackbar(
                              "Type a valid password at least 6 Characters",
                              context);
                        } else {
                          loginUser(context);
                        }
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.yellow.shade600),
                      ),
                      child: Container(
                        height: 50.0,
                        alignment: Alignment.center,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Brand Bold',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegisterScreen.idScreen, (route) => false);
                },
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginUser(BuildContext context) async {
    final User? user = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((error) {
      showSnackbar("Error: ${error.toString()}", context);
    }))
        .user;

    if (user != null) {
      userRef.child(user.uid).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.idScreen, (route) => false);
        } else {
          _firebaseAuth.signOut();
          showSnackbar(
              "user with no data. Please create a new account", context);
        }
      });
    } else {
      showSnackbar("User not exists", context);
    }
  }

  void showSnackbar(String msg, BuildContext context) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
