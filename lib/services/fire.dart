import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallapp/pages/homepage.dart';
import 'package:wallapp/pages/signin.dart';

class Fire {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  googleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential).then(
        (value) {
          _firestore.collection("Users").doc("${value.user!.uid}").set(
            {
              "name": googleUser.displayName,
              "email": googleUser.email,
              "profilePic": googleUser.photoUrl,
              "lastSignIn": DateTime.now()
            },
          );
        },
      ).whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new HomePage(),
          ),
        );
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut(BuildContext context) async {
    await _auth.signOut().whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new SignIn(),
        ),
      );
    });
  }

  Future<User?> getData() async {
    return _auth.currentUser;
  }
}
