import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_rider_app/main.dart';
import 'package:my_rider_app/screens/home_screen.dart';
import 'package:my_rider_app/screens/login_screen.dart';
import 'package:my_rider_app/widgets/progress_dialog.dart';

class RegisterScreen extends StatelessWidget {
  static const String idScreen = "register";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
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
                'Register as Rider',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontFamily: 'Brand Bold'),
              ),
              const SizedBox(height: 1.0),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "name",
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
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
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
                        if (nameController.text.trim().length < 4) {
                          showSnackbar("Type a valid name", context);
                        } else if (!emailController.text.trim().contains('@') &&
                            !emailController.text.contains('.')) {
                          showSnackbar("Type a valid email", context);
                        } else if (phoneController.text.trim().isEmpty) {
                          showSnackbar("Type a valid phone", context);
                        } else if (passwordController.text.trim().length < 6) {
                          showSnackbar(
                              "Type a valid password at least 6 Characters",
                              context);
                        } else {
                          registerNewUser(context);
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
                          "Create Account",
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
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text('Already have an account? Login Here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog('Loading, Please Wait...');
        });

    final User? user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((error) {
      Navigator.pop(context);
      showSnackbar("Error: ${error.toString()}", context);
    }))
        .user;

    if (user != null) {
      Map userDataMap = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
      };
      userRef.child(user.uid).set(userDataMap);
      showSnackbar("Account created", context);

      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.idScreen, (route) => false);
    } else {
      showSnackbar("Account not created", context);
      Navigator.pop(context);
    }
  }

  void showSnackbar(String msg, BuildContext context) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
