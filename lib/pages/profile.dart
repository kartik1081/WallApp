import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallapp/config/config.dart';
import 'package:wallapp/pages/editprofile.dart';

import 'addwallpaper.dart';
import 'wallpaper_view_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  late File _image;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        child: new SingleChildScrollView(
          child: new Stack(
            children: [
              new Column(
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
                            color: Colors.white.withOpacity(0.7),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                new StreamBuilder<dynamic>(
                                  stream: _firestore
                                      .collection("Users")
                                      .doc("${_auth.currentUser!.uid}")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map<String, dynamic> data =
                                          snapshot.data.data();
                                      return new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          new InkWell(
                                            onTap: () {
                                              getImage();
                                            },
                                            child: new ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: data["profilePic"] == null
                                                  ? new Image(
                                                      image: AssetImage(
                                                          "assets/avatar.png"),
                                                      height: 65,
                                                      width: 65,
                                                    )
                                                  : new CachedNetworkImage(
                                                      height: 65,
                                                      width: 65,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          data["profilePic"],
                                                      placeholder:
                                                          (context, url) {
                                                        return new Container(
                                                          height: 100,
                                                          child: new Center(
                                                            child:
                                                                new CircularProgressIndicator(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                            ),
                                          ),
                                          new SizedBox(
                                            width: 10,
                                          ),
                                          new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              new Text(
                                                data["name"],
                                                style: new TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              new Text(
                                                data["email"],
                                                style: new TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    }
                                    return new CircularProgressIndicator();
                                  },
                                ),
                                new SizedBox(
                                  height: 10,
                                ),
                                new Container(
                                  width: 300,
                                  decoration: new BoxDecoration(),
                                  child: new ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new EditProfile(),
                                            fullscreenDialog: true),
                                      );
                                    },
                                    child: new Text(
                                      "Edit Profile",
                                      style:
                                          new TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new SizedBox(
                    height: 50.0,
                  ),
                  if (_auth.currentUser != null) ...[
                    new StreamBuilder<dynamic>(
                      stream: _firestore
                          .collection("Wallpaper")
                          .where("uploadBy", isEqualTo: _auth.currentUser!.uid)
                          // .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return new StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            staggeredTileBuilder: (int i) =>
                                StaggeredTile.fit(1),
                            itemBuilder: (BuildContext context, int index) {
                              return new InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => new WallpaperView(
                                            image: snapshot.data.docs[index]
                                                ["url"]),
                                        fullscreenDialog: true),
                                  );
                                },
                                child: new Stack(
                                  children: [
                                    new Hero(
                                      tag: snapshot.data.docs[index]["url"],
                                      child: new Card(
                                        elevation: 7.0,
                                        shadowColor: Colors.black,
                                        semanticContainer: true,
                                        child: new ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          child: new CachedNetworkImage(
                                            imageUrl: snapshot.data.docs[index]
                                                ["url"],
                                            placeholder: (context, url) {
                                              return new Center(
                                                child:
                                                    new CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    new IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return new AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                                title: new Text("Confirmation"),
                                                content: new Text(
                                                    "Are yor sure, you are deleting wallpaper."),
                                                actions: [
                                                  new TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: new Text("Cancel"),
                                                  ),
                                                  new TextButton(
                                                    onPressed: () {
                                                      print("Start");
                                                      _firestore
                                                          .collection(
                                                              "Wallpaper")
                                                          .doc(snapshot
                                                              .data
                                                              .docs[index]
                                                              .documentId)
                                                          .delete();
                                                      print("End");
                                                      Navigator.pop(context);
                                                    },
                                                    child: new Text("Delete"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      icon: new Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return new Container(
                          padding: const EdgeInsets.only(
                              top: 40, left: 20, right: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.494,
                          child: !snapshot.hasData
                              ? Center(
                                  child: new Text("Profile is Empty"),
                                )
                              : SpinKitChasingDots(
                                  duration: Duration(seconds: 2),
                                  color: primaryColor,
                                  size: 50,
                                ),
                        );
                      },
                    ),
                  ],
                ],
              ),
              new Positioned(
                top: 220,
                left: 170,
                child: new FloatingActionButton(
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
        ),
      ),
    );
  }

  Future getImage() async {
    try {
      final pickedFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 30);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _storage
            .ref()
            .child("ProfilePic")
            .child("${_auth.currentUser!.uid}")
            .putFile(_image)
            .then((value) {
          if (value.state == TaskState.running) {}
          if (value.state == TaskState.success) {
            value.ref.getDownloadURL().then((value) async {
              await _firestore
                  .collection("Users")
                  .doc("${_auth.currentUser!.uid}")
                  .update({
                "profilePic": value,
              });
            });
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
