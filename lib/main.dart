import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallapp/config/config.dart';
import 'package:wallapp/pages/signin.dart';

import 'pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    messaging.subscribeToTopic("promotion");
    this.initDynamicLinks();
    super.initState();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (linkData) async {
        // ignore: unnecessary_statements
        linkData!.link;
      },
      onError: (error) async {
        print("onLinkError");
        print(error.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flut',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme)),
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
        primaryColor: primaryColor,
        brightness: Brightness.dark,
      ),
      home: new StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new HomePage();
          } else {
            return new SignIn();
          }
        },
      ),
    );
  }
}
