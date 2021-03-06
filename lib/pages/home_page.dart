import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wordpower_official_app/constant/story_json.dart';
import 'package:wordpower_official_app/pages/root_app.dart';
import 'package:wordpower_official_app/pages/widget/post_screen.dart';
import 'package:wordpower_official_app/pages/widget/story/image_story.dart';
import 'package:wordpower_official_app/pages/widget/story/story_list_collection.dart';
import 'package:wordpower_official_app/pages/widget/story/text_story.dart';
import 'package:wordpower_official_app/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File singleImage;
  final singlePicker = ImagePicker();
  String url = "";
  User user = FirebaseAuth.instance.currentUser;
  String myProfileImage = "";
  List postList = [];
  List postSaved = [];
  List imageList = [];
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool uploadStatus = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          setState(() {
            uploadStatus = false;
          });
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: uploadStatus == true
              ? FabCircularMenu(
                  fabColor: const Color.fromARGB(255, 87, 87, 87),
                  ringColor: const Color.fromARGB(255, 87, 87, 87),
                  fabSize: 60,
                  fabElevation: 5,
                  ringWidth: 80,
                  ringDiameter: 400,
                  fabOpenIcon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  fabCloseIcon: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.white,
                  ),
                  children: <Widget>[
                      IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // print('Home');
                          }),
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.pen,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return const TextStory();
                          }));
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.video_camera,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          // print('Favorite');
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.photo_camera,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {
                          // print('Favorite');
                          handleImage();
                        },
                      ),
                    ])
              : null,
          body: getBody(),
        ));
  }

  getBody() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        // user.reload();
        if (snapshot.hasError) {
          return const Text(
            "Something went wrong",
            style: TextStyle(
              color: Colors.white,
            ),
          );
        } else if (snapshot.hasData || snapshot.data != null) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;
          data["postSaved"] != null
              ? postSaved = data["postSaved"]
              : postSaved = [];
          myProfileImage = data["profileImage"];
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 2));
              updateData();
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, left: 15, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 65,
                                width: 65,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          uploadStatus = true;
                                        });
                                      },
                                      child: Container(
                                        height: 65,
                                        width: 65,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              myProfileImage,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 19,
                                        height: 19,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: white,
                                        ),
                                        child: const Icon(
                                          Icons.add_circle,
                                          color: buttonFollowColor,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: white,
                                    fontFamily: "RedHatDisplay",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const StoryListCollection(),
                      ],
                    ),
                  ),
                  Divider(
                    color: white.withOpacity(0.3),
                  ),
                  PostItem(
                    profileImage: myProfileImage,
                    postSaved: postSaved,
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        );
      },
    );
  }

  void handleImage() async {
    final pickedImage =
        await singlePicker.pickImage(source: (ImageSource.camera));
    setState(
      () {
        if (pickedImage != null) {
          singleImage = File(pickedImage.path);
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ImageStory(image: singleImage);
          }));
          // uploadImage(userId);
        } else {
          Fluttertoast.showToast(msg: "No image is selected");
        }
      },
    );
  }

  void updateData() {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      // int i = data.length+1;
      // data.add("Flutter Tutorial $i");
      timer.cancel();
      // setState(() {});
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return RootApp();
      }));
    });
  }
}
