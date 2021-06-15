import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
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
        ],
      ),
    ));
  }
}
