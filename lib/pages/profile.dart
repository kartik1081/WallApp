import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/pages/editprofile.dart';

import 'addwallpaper.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          new Container(
            child: new Column(
              children: [
                new ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                  child: new Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    color: Colors.white,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              child: new FadeInImage(
                                height: 80,
                                width: 80,
                                placeholder:
                                    new AssetImage("assets/avatar.png"),
                                image: new NetworkImage(
                                    "${_auth.currentUser!.photoURL}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            new SizedBox(
                              width: 10,
                            ),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(
                                  "${_auth.currentUser!.displayName}",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                new Text(
                                  "${_auth.currentUser!.email}",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        new SizedBox(
                          height: 10,
                        ),
                        new Container(
                          width: 350,
                          decoration: new BoxDecoration(),
                          child: new ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new EditProfile(),
                                    fullscreenDialog: true),
                              );
                            },
                            child: new Text("Edit Profile"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Positioned(
            top: 220,
            left: 170,
            child: new FloatingActionButton(
              elevation: 7.0,
              backgroundColor: Colors.black,
              child: new Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new AddWallpaper(),
                      fullscreenDialog: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
