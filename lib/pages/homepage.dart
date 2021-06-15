import 'package:flutter/material.dart';
import 'package:wallapp/config/config.dart';
import 'package:wallapp/pages/explore.dart';
import 'package:wallapp/pages/favorite.dart';
import 'package:wallapp/pages/profile.dart';
import 'package:wallapp/services/fire.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Fire _fire = Fire();
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: new Row(
            children: [
              new Text(
                "Wall",
                style: new TextStyle(color: primaryColor),
              ),
              new Text(
                "App",
                style: new TextStyle(color: secondaryColor),
              )
            ],
          ),
          actions: [
            new IconButton(
              onPressed: () {
                _fire.signOut(context);
              },
              icon: new Icon(Icons.logout),
            ),
          ],
        ),
        body: new TabBarView(
            children: [new Explore(), new Favorite(), new Profile()]),
        bottomNavigationBar: new TabBar(
          tabs: [
            Tab(icon: new Icon(Icons.search)),
            Tab(
              icon: new Icon(Icons.favorite_outline),
            ),
            Tab(
              icon: new Icon(Icons.person_outline),
            ),
          ],
          labelColor: Colors.yellow,
          unselectedLabelColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Colors.red,
        ),
      ),
    );
  }
}
