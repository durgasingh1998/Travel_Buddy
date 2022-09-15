import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_buddy/screens/dashboard.dart';
import 'package:travel_buddy/widgets/login.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/SplashScreen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    Timer(Duration(seconds: 6), () {
      if (auth.currentUser == null) {
        Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
      } else {
        Navigator.pushReplacementNamed(context, DashBoardScreen.ROUTE_NAME);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 213, 97),
        body: Center(
          child: Container(
            height: 400,
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                )
              ],
            ),
          ),
        ));
  }
}
