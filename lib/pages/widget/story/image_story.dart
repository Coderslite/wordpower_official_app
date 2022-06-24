import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordpower_official_app/pages/root_app.dart';

class ImageStory extends StatefulWidget {
  final File image;
  const ImageStory({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  State<ImageStory> createState() => _ImageStoryState();
}

class _ImageStoryState extends State<ImageStory> {
  User user = FirebaseAuth.instance.currentUser;
  final TextEditingController _message = TextEditingController();
  String url = "";
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Image Story"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(widget.image),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: _message,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                        hintText: "Your Caption",
                        hintStyle: TextStyle(
                          color: Colors.white30,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    onPressed: () {
                    },
                    icon:
                        const Icon(Icons.emoji_emotions, color: Colors.yellow),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: isUploading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          onPressed: () {
                            uploadImage(user.uid, _message.text);
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future uploadImage(userId, message) async {
    setState(() {
      isUploading = true;
    });
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('users/')
        .child('$userId / story');
    firebase_storage.UploadTask task = ref.putFile(widget.image);
    firebase_storage.TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    task.then((p0) {
      updateFirestoreImage(userId, message, url);
    });
  }

  updateFirestoreImage(userId, message, url) {
    DocumentReference storyCreation =
        FirebaseFirestore.instance.collection("story_collection").doc(user.uid);
    DocumentReference storyCollection = FirebaseFirestore.instance
        .collection("story_collection")
        .doc(user.uid)
        .collection(user.uid)
        .doc();
    Map<String, dynamic> storyCreate = {
      "userId": user.uid,
      "time": DateTime.now().microsecondsSinceEpoch,
    };
    storyCreation.set(storyCreate).whenComplete(() {
      Map<String, dynamic> textStory = {
        "caption": message,
        "url": url,
        "time": DateTime.now().microsecondsSinceEpoch,
        "type": "image",
        "story_viewers": [],
        "storyId": storyCollection.id,
      };
      storyCollection.set(textStory).whenComplete(() {
        _message.clear();
        Fluttertoast.showToast(msg: "upload story successful");
        setState(() {
          isUploading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return const RootApp();
        }));
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.message);
    });
  }
}
