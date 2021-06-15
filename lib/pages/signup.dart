import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallapp/services/fire.dart';

import 'signin.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // ignore: unused_field
  final _form = GlobalKey<FormState>();
  Fire _fire = Fire();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF00BF6D),
      body: new SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: new Stack(
            children: [
              new Positioned(
                top: height * 0.17,
                height: height * 40,
                right: 20,
                left: 20,
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                  child: new BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: new Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200]!.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[900]!.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new SizedBox(
                            height: 20,
                          ),
                          new Text(
                            "Sign Up",
                            style: new TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                          new SizedBox(
                            height: 50,
                          ),
                          new Form(
                            child: new Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter your name";
                                      }
                                    },
                                    controller: name,
                                    cursorHeight: 22.0,
                                    decoration: new InputDecoration(
                                      hintText: "Enter your name",
                                      hintStyle:
                                          new TextStyle(color: Colors.grey),
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          13.0, -5.0, 0.0, -5.0),
                                      focusedBorder: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              width: 0.0000000001,
                                              color: Colors.black),
                                          borderRadius:
                                              new BorderRadius.circular(10.0)),
                                      enabledBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            width: 0.0000000001,
                                            color: Colors.white),
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  new SizedBox(
                                    height: 10.0,
                                  ),
                                  new TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter your email";
                                      }
                                    },
                                    controller: email,
                                    cursorHeight: 22.0,
                                    decoration: new InputDecoration(
                                      hintText: "Enter your email",
                                      hintStyle:
                                          new TextStyle(color: Colors.grey),
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          13.0, -5.0, 0.0, -5.0),
                                      focusedBorder: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              width: 0.0000000001,
                                              color: Colors.black),
                                          borderRadius:
                                              new BorderRadius.circular(10.0)),
                                      enabledBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            width: 0.0000000001,
                                            color: Colors.white),
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  new SizedBox(
                                    height: 10.0,
                                  ),
                                  new TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter your password";
                                      }
                                    },
                                    controller: password,
                                    cursorHeight: 30.0,
                                    decoration: new InputDecoration(
                                      hintText: "Enter your password",
                                      hintStyle:
                                          new TextStyle(color: Colors.grey),
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          13.0, -5.0, 0.0, -5.0),
                                      focusedBorder: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              width: 0.0000000001,
                                              color: Colors.black),
                                          borderRadius:
                                              new BorderRadius.circular(10.0)),
                                      enabledBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            width: 0.0000000001,
                                            color: Colors.white),
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: new Container(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new TextButton(
                                  child: Text(
                                    "Already have account",
                                    style: new TextStyle(
                                        fontSize: 14.0, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        // ignore: non_constant_identifier_names
                                        builder: (BuildContext) => new SignIn(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          new Container(
                            width: 110,
                            child: new ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(7),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.lightGreen),
                              ),
                              onPressed: () {},
                              child: new Text("Sign Up"),
                            ),
                          ),
                          new SizedBox(
                            height: 25,
                          ),
                          new Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                new Expanded(
                                  child: new ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        elevation:
                                            MaterialStateProperty.all(7.0)),
                                    onPressed: () {
                                      _fire.googleSignIn(context);
                                    },
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        new Image.asset("assets/google.jpg"),
                                        new SizedBox(
                                          width: 7.0,
                                        ),
                                        new Text(
                                          "Google",
                                          style: new TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                new SizedBox(width: 15.0),
                                new Expanded(
                                  child: new ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                      elevation: MaterialStateProperty.all(7.0),
                                    ),
                                    onPressed: () {
                                      // _flutterFire.signInWithFacebook(context);
                                    },
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        new Icon(Icons.facebook),
                                        new SizedBox(
                                          width: 5.0,
                                        ),
                                        new Text(
                                          "Facebook",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
