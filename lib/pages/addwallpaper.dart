import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class AddWallpaper extends StatefulWidget {
  const AddWallpaper({Key? key}) : super(key: key);

  @override
  _AddWallpaperState createState() => _AddWallpaperState();
}

class _AddWallpaperState extends State<AddWallpaper> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late bool isUploading;
  late bool isCompletedUploading;
  late bool image;
  late File _image;
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    image = false;
    isUploading = false;
    isCompletedUploading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        title: new Text("Add Wallpaper"),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          child: new Column(
            children: [
              image
                  ? new Container(
                      height: 220,
                      child: new Image(
                        image: FileImage(_image),
                      ),
                    )
                  : new InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: new Container(
                        color: Colors.grey,
                        height: 220,
                        child: new Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Icon(Icons.add_a_photo),
                              new Text("Click hear to add"),
                            ],
                          ),
                        ),
                      ),
                    ),
              new SizedBox(
                height: 20,
              ),
              new Container(
                child: new ElevatedButton(
                  onPressed: () {
                    uploadWallpaper();
                  },
                  child: new Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 30);

    setState(() {
      _image = File(pickedFile!.path);
      image = !image;
    });
  }

  void uploadWallpaper() async {
    // ignore: unnecessary_null_comparison
    if (_image != null) {
      String path = p.basename(_image.path);
      _storage
          .ref()
          .child("Wallpapers")
          .child("${_auth.currentUser!.uid}")
          .child("$path")
          .putFile(_image)
          .then((e) {
        if (e.state == TaskState.running) {
          setState(() {
            isUploading = true;
          });
        }
        if (e.state == TaskState.success) {
          setState(() {
            isCompletedUploading = true;
            isUploading = false;
          });
          e.ref.getDownloadURL().then((value) async {
            print("Start");
            await _firestore.collection("Wallpaper").add({
              "uid": value,
              "time": DateTime.now(),
              "uploadBy": _auth.currentUser!.uid
            });
            print("end");
            Navigator.pop(context);
          });
        }
      });

      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: new Text("Error"),
            content: new Text("Select image to upload..."),
            actions: [
              new InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: new Container(
                  child: new Text("Ok"),
                ),
              )
            ],
          );
        },
      );
    }
  }
}
