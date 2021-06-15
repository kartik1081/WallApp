import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      body: new SingleChildScrollView(
        child: new Container(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
