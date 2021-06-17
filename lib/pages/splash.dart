import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wallapp/config/config.dart';

import 'homepage.dart';
import 'signin.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    new Timer(
      Duration(seconds: 4),
      () => _auth.authStateChanges().listen(
        (event) {
          if (event != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new HomePage(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new SignIn(),
              ),
            );
          }
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Expanded(
              child: new Image(
                image: AssetImage("assets/wallpaper.jpg"),
                height: 100,
                width: 100,
              ),
            ),
            new SpinKitCircle(
              color: primaryColor,
              size: 30,
            ),
            new SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
