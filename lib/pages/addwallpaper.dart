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
        elevation: 0,
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
                      width: MediaQuery.of(context).size.width,
                      child: new Image(
                        fit: BoxFit.fitWidth,
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
              new SizedBox(
                height: 20,
              ),
              if (isUploading) ...[new Text("Photo is Uploading...")],
              if (isCompletedUploading) ...[
                new Text("Photo uploading Completed.")
              ],
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

      setState(() {
        _image = File(pickedFile!.path);
        image = !image;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void uploadWallpaper() async {
    try {
      // ignore: unnecessary_null_comparison
      if (_image == null) {
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
      } else {
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
            e.ref.getDownloadURL().then((value) async {
              print("Start");
              await _firestore.collection("Wallpaper").add({
                "url": value,
                "time": DateTime.now(),
                "uploadBy": _auth.currentUser!.uid,
              });

              print("end");
            });
          }
        });
        setState(() {
          isUploading = false;
          isCompletedUploading = true;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
