import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../post_image_list.dart';

class SavedPostList extends StatefulWidget {
  const SavedPostList({Key key}) : super(key: key);

  @override
  _SavedPostListState createState() => _SavedPostListState();
}

class _SavedPostListState extends State<SavedPostList> {
  User user = FirebaseAuth.instance.currentUser;
  List imageList = [];
  List postSaved = [];
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Saved Post"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  Map data = snapshot.data.data() as Map;
                  postSaved = data["postSaved"];
                  // print(postSaved);
                  return postSaved.isNotEmpty
                      ? StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("post")
                              .where('postId', whereIn: postSaved)
                              .snapshots(),
                          builder: (context, snapshot2) {
                            if (snapshot2.hasError) {
                              return const Text(
                                "Something went wrong",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "RedHatDisplay",
                                ),
                              );
                            } else if (snapshot2.data.docs.isEmpty) {
                              return const Text(
                                "No saved post",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "RedHatDisplay",
                                ),
                              );
                            } else if (snapshot2.hasData ||
                                snapshot2.data != null) {
                              var data = snapshot2.data.docs;
                              return Column(
                                  children: List.generate(
                                      snapshot2.data.docs.length, (index) {
                                imageList = data[index]["imageUrl"];

                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      imageList.length <= 1
                                          ? InteractiveViewer(
                                              child:
                                                  Image.network(imageList[0]))
                                          : carouselSlider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 3),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data[index]['date'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "RedHatDisplay",
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                handleUnsavedPost(user.uid,
                                                    data[index]['postId']);
                                              },
                                              icon: Icon(
                                                CupertinoIcons.bookmark_solid,
                                                color: Colors.red,
                                                size: 25,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: size.width - 50,
                                            child: Text(
                                              data[index]["description"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "RedHatDisplay",
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Divider(color: Colors.white30),
                                      SizedBox(
                                        height: 40,
                                      ),
                                    ]);
                              }));
                            }
                            return CircularProgressIndicator();
                          })
                      : Center(
                          child: const Text(
                            "No Saved Post",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RedHatDisplay",
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column carouselSlider() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            autoPlay: false,
            aspectRatio: 2.0,
            viewportFraction: 1,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: imageList
              .map(
                (item) => Container(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.network(item, fit: BoxFit.cover, width: 1000.0),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              // child: Text(
                              //   'No. ${imgList.indexOf(item)} image',
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 20.0,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        CarouselIndicator(
            imgList: imageList, controller: _controller, current: _current),
      ],
    );
  }

  void handleUnsavedPost(String userId, String postId) {
    DocumentReference savePost =
        FirebaseFirestore.instance.collection("users").doc(userId);
    if (postSaved.contains(postId)) {
      // handleUnliked(postId, userId, postLiked);
    }
    postSaved.remove(postId);
    savePost.update({'postSaved': postSaved});
    Fluttertoast.showToast(
        msg: "You have successfully removed post from saved collection");
    // postLiked.clear();
  }
}
