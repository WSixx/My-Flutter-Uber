// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_rider_app/screens/home_screen.dart';
import 'package:my_rider_app/screens/login_screen.dart';
import 'package:my_rider_app/screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child('users');

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Rider APP',
            theme: ThemeData(
              fontFamily: "Brand-Regular",
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: LoginScreen.idScreen,
            routes: {
              RegisterScreen.idScreen: (context) => RegisterScreen(),
              LoginScreen.idScreen: (context) => LoginScreen(),
              HomeScreen.idScreen: (context) => HomeScreen(),
            },
          );
        }
        return _loadingWidget();
      },
    );
  }

  Widget _loadingWidget() {
    return CircularProgressIndicator();
  }
}
