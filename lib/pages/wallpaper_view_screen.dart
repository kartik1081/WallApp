import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/config/config.dart';

class WallpaperView extends StatefulWidget {
  final String image;
  const WallpaperView({Key? key, required this.image}) : super(key: key);

  @override
  _WallpaperViewState createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
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
                new Card(
                  shadowColor: Colors.grey,
                  elevation: 7.0,
                  child: new Container(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
