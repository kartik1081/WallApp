import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:wallapp/config/config.dart';
import 'package:wallapp/pages/explore.dart';
import 'package:wallapp/pages/favorite.dart';
import 'package:wallapp/pages/profile.dart';
import 'package:wallapp/services/fire.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
          children: [
            new Explore(),
            new Favorite(),
            new Profile(),
          ],
        ),
        bottomNavigationBar: new Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: new SafeArea(
            child: new Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: new GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[400]!,
                color: Colors.black,
                tabs: [
                  GButton(
                    icon: LineIcons.search,
                    text: "Explore",
                  ),
                  GButton(
                    icon: LineIcons.heart,
                    text: "Favorite",
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
