import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallapp/config/config.dart';

import 'wallpaper_view_screen.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String user;

  Future<String> _getUser() async {
    var u = _auth.currentUser!.uid;
    setState(() {
      user = u;
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
        child: Container(
      child: new Column(
        children: [
          new SizedBox(
            height: 20,
          ),
          new Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 5, left: 20, bottom: 5),
            child: new Text(
              "Favorite",
              style: new TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
          if (_getUser() != null) ...[
            new StreamBuilder<dynamic>(
              stream: _firestore
                  .collection("Users")
                  .doc("$_getUser()")
                  .collection("Favorites")
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return new StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    staggeredTileBuilder: (int i) => StaggeredTile.fit(1),
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new WallpaperView(
                                    image: snapshot.data.docs[index]["url"]),
                                fullscreenDialog: true),
                          );
                        },
                        child: new Hero(
                          tag: snapshot.data.docs[index].data["url"],
                          child: new Card(
                            elevation: 7.0,
                            shadowColor: Colors.grey,
                            semanticContainer: true,
                            child: new ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              child: new CachedNetworkImage(
                                imageUrl: snapshot.data.docs[index].data["url"],
                                placeholder: (context, url) {
                                  return new Center(
                                    child: new CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return SpinKitChasingDots(
                    color: primaryColor,
                    size: 50,
                  );
                }
              },
            ),
          ]
        ],
      ),
    ));
  }
}
