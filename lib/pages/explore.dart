import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallapp/config/config.dart';
import 'package:wallapp/pages/wallpaper_view_screen.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: Container(
        child: new Column(
          children: [
            new SizedBox(
              height: 5,
            ),
            new Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 0, left: 20, bottom: 5),
              child: new Text(
                "Explore",
                style: new TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            new StreamBuilder<dynamic>(
              stream: _firestore
                  .collection("Wallpaper")
                  .orderBy("time", descending: true)
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
                                imageUrl: snapshot.data.docs[index]["url"],
                                placeholder: (context, url) {
                                  return new Container(
                                    height: 100,
                                    child: new Center(
                                      child: new CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return SpinKitChasingDots(
                  color: primaryColor,
                  size: 50,
                );
              },
            ),
            new SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
