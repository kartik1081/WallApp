import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:share/share.dart';
import 'package:wallapp/config/config.dart';

class WallpaperView extends StatefulWidget {
  final String image;
  const WallpaperView({Key? key, required this.image}) : super(key: key);

  @override
  _WallpaperViewState createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        title: new Row(
          children: [
            new Text(
              "Wall",
              style: new TextStyle(color: primaryColor),
            ),
            new Text(
              "App",
              style: new TextStyle(color: secondaryColor),
            ),
          ],
        ),
      ),
      body: new SafeArea(
        child: new SingleChildScrollView(
          child: new Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: MediaQuery.of(context).size.width,
            child: new Column(
              children: [
                new Container(
                  child: new Hero(
                    tag: widget.image,
                    child: new CachedNetworkImage(
                      imageUrl: widget.image,
                      placeholder: (context, url) {
                        return new Center(
                          child: new CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin: const EdgeInsets.only(top: 20),
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new ElevatedButton(
                        onPressed: () {
                          _launchURL();
                        },
                        child: new Row(
                          children: [
                            new Icon(Icons.download),
                            new SizedBox(
                              width: 5,
                            ),
                            new Text("Download")
                          ],
                        ),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new ElevatedButton(
                        onPressed: () {
                          _createDynamicLink();
                        },
                        child: new Row(
                          children: [
                            new Icon(Icons.share),
                            new SizedBox(
                              width: 5,
                            ),
                            new Text("Share")
                          ],
                        ),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new ElevatedButton(
                        onPressed: () {
                          _addToFavorite();
                        },
                        child: new Row(
                          children: [
                            new Icon(Icons.favorite),
                            new SizedBox(
                              width: 5,
                            ),
                            new Text("favorite")
                          ],
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
    );
  }

  void _launchURL() async {
    try {
      await launch(
        widget.image,
        customTabsOption: CustomTabsOption(toolbarColor: primaryColor),
      );
    } catch (e) {}
  }

  void _addToFavorite() async {
    try {
      String user = _auth.currentUser!.uid;
      _firestore.collection("Users").doc("$user").collection("Favorites").add({
        "url": widget.image,
        "time": DateTime.now(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _createDynamicLink() async {
    try {
      DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
        uriPrefix: "https://wall10app81.page.link",
        link: Uri.parse(widget.image),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: "WallApp",
          description: "For cool wallpaper",
          imageUrl: Uri.parse(widget.image),
        ),
        androidParameters: AndroidParameters(
            packageName: "com.wall.wallapp", minimumVersion: 0),
      );
      Uri uri = await dynamicLinkParameters.buildUrl();
      String url = uri.toString();
      Share.share(url);
    } catch (e) {
      print(e.toString());
    }
  }
}
