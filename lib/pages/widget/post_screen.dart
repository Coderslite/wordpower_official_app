import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:wordpower_official_app/pages/widget/comment_list.dart';
import 'package:wordpower_official_app/pages/widget/comment_view.dart';
import 'package:wordpower_official_app/pages/widget/post_details.dart';
import 'package:wordpower_official_app/theme/colors.dart';
import 'package:intl/intl.dart';

class PostItem extends StatefulWidget {
  final String profileImage;
  final List postSaved;
  const PostItem({
    Key key,
    this.profileImage,
    this.postSaved,
  }) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem>
    with SingleTickerProviderStateMixin {
  final double minScale = 1;
  final double maxScale = 4;
  TransformationController controller;
  AnimationController animationController;
  Animation<Matrix4> animation;
  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 200,
        ))
      ..addListener(() => controller.value = animation.value);
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    animationController.forward(from: 0);
  }

  bool overFlow = false;
  final ScrollController _scrollController = ScrollController();
  List imageList = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  User user = FirebaseAuth.instance.currentUser;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  String _message = "";

  handleAddComment(String comment, String postId, String profileImage) {
    DocumentReference commentReference =
        FirebaseFirestore.instance.collection("comments").doc();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    Map<String, dynamic> commentDetails = {
      "postId": postId,
      "comment": comment,
      "commenter": user.uid,
      "commentId": commentReference.id,
      "profileImage": profileImage,
      "date": formatted,
      "time": now.microsecondsSinceEpoch.toString(),
      "commentLike": [],
    };

    commentReference.set(commentDetails).whenComplete(
      () {
        setState(() {
          _message = "";
        });
        _messageController.clear();
        Fluttertoast.showToast(msg: "Comment Posted");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("post")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot2) {
          if (snapshot2.hasError) {
            return const Text(
              "Something went wrong",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          } else if (snapshot2.hasData || snapshot2.data != null) {
            return Column(children: [
              ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: snapshot2.data?.docs?.length,
                itemBuilder: (BuildContext context, int index) {
                  List postLiked = [];
                  // print(snapshot.data!.docs.length);
                  QueryDocumentSnapshot<Object> documentSnapshot =
                      snapshot2.data?.docs[index];
                  int descriptionLength =
                      (documentSnapshot["description"]).length;
                  // print(descriptionLength);
                  imageList = (documentSnapshot["imageUrl"]);
                  var dateInt = int.parse(documentSnapshot["time"]);
                  // print(dateInt);
                  var currentDate =
                      DateTime.fromMicrosecondsSinceEpoch(dateInt);
                  var newDate =
                      DateFormat('MM/dd/yyyy,hh:mm a').format(currentDate);
                  DateTime newPostDate =
                      DateFormat('MM/dd/yyyy,hh:mm a').parse(newDate);
                  // print(newPostDate);
                  (documentSnapshot["postLiked"]) != null
                      ? postLiked = (documentSnapshot["postLiked"])
                      : postLiked = [];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/wordpower-ministry-app.appspot.com/o/logo%2Flogo.png?alt=media&token=4e35bf75-17c6-455b-bedf-46c2dfb4dfb5'),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Text(
                                    "Wordpower Ministry",
                                    style: TextStyle(
                                      color: white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "RedHatDisplay",
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  LineIcons.horizontalEllipsis,
                                  color: white,
                                ),
                                onPressed: () {
                                  showBottomSheet(
                                      context,
                                      (documentSnapshot != null)
                                          ? (documentSnapshot["imageUrl"]
                                              [index])
                                          : "",
                                      (documentSnapshot != null)
                                          ? (documentSnapshot["postId"][index])
                                          : "",
                                      (documentSnapshot != null)
                                          ? (documentSnapshot["description"]
                                              [index])
                                          : "");
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: GestureDetector(
                            child: Container(
                              child: imageList.length <= 1
                                  ? InteractiveViewer(
                                      transformationController: controller,
                                      clipBehavior: Clip.none,
                                      minScale: minScale,
                                      maxScale: maxScale,
                                      panEnabled: false,
                                      onInteractionEnd: (details) {
                                        resetAnimation();
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: imageList[0],
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                JumpingDotsProgressIndicator(
                                          fontSize: 20.0,
                                          color: Colors.blue,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    )
                                  : carouselSlider(),
                            ),
                            // onTap: () {
                            //   Navigator.push(context, MaterialPageRoute(builder: (_) {
                            //     return PostImageList(
                            //         postId: widget.id, imageList:widget.imgList);
                            //   }));
                            //   // Navigator.push(context, MaterialPageRoute(builder: (_) {
                            //   //   return DetailScreen(postImg: widget.postImg, id: widget.id);
                            //   // }));
                            // },
                            onLongPress: () {
                              handleLiked((documentSnapshot["postId"]),
                                  user.uid, postLiked);
                            },
                          ),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  postLiked.contains(user.uid)
                                      ? IconButton(
                                          onPressed: () {
                                            handleUnliked(
                                                (documentSnapshot["postId"]),
                                                user.uid,
                                                postLiked);
                                          },
                                          icon: const Icon(
                                            CupertinoIcons.heart_solid,
                                            size: 27,
                                            color: Colors.red,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            handleLiked(
                                                (documentSnapshot["postId"]),
                                                user.uid,
                                                postLiked);
                                          },
                                          icon: const Icon(
                                            CupertinoIcons.heart,
                                            size: 27,
                                            color: white,
                                          ),
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return CommentViewScreen(
                                              postId:
                                                  documentSnapshot["postId"],
                                              profileImage:
                                                  widget.profileImage);
                                        }));
                                      },
                                      child: const Icon(
                                          CupertinoIcons.chat_bubble,
                                          size: 27,
                                          color: Colors.white)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: const Icon(
                                      CupertinoIcons.share,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                    onTap: () => shareModal(context),
                                  ),
                                ],
                              ),
                              // SvgPicture.asset(
                              //   "images/bookmark_icon.svg",
                              //   color: Colors.white,
                              //   width: 25,
                              // )
                              widget.postSaved
                                      .contains(documentSnapshot['postId'])
                                  ? IconButton(
                                      onPressed: () {
                                        handleUnsavedPost(user.uid,
                                            documentSnapshot['postId']);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.bookmark_solid,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        handleSavedPost(user.uid,
                                            documentSnapshot['postId']);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.bookmark,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: postLiked.length < 2
                              ? Text(
                                  postLiked.length.toString() + " like",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "RedHatDisplay",
                                  ),
                                )
                              : Text(
                                  postLiked.length.toString() + " likes",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "RedHatDisplay",
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: postLiked.isEmpty
                                ? const Text(
                                    "",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const Text(
                                    "",
                                    style: TextStyle(color: Colors.white),
                                  )),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      descriptionLength > 2
                                          ? Text(
                                              (documentSnapshot["description"]),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: "RedHatDisplay",
                                              ),
                                            )
                                          : Text(
                                              (documentSnapshot["description"]),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: "RedHatDisplay",
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        commentList(
                            documentSnapshot: documentSnapshot, widget: widget),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                widget.profileImage),
                                            fit: BoxFit.cover)),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: size.width - 140,
                                    // height: 55,
                                    child: TextField(
                                      controller: _messageController,
                                      onChanged: (value) {
                                        setState(() {
                                          _message = value;
                                        });
                                      },
                                      minLines: 1,
                                      maxLines: 5,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "Add your comments",
                                        hintStyle: const TextStyle(
                                          color: Colors.white54,
                                          fontFamily: "RedHatDisplay",
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 1),
                                  IconButton(
                                    icon: _message == null || _message.isEmpty
                                        ? Icon(Icons.add_circle,
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            size: 18)
                                        : const Icon(Icons.add_circle,
                                            color: Colors.blue, size: 18),
                                    onPressed: () {
                                      _message == null || _message.isEmpty
                                          ? null
                                          : handleAddComment(
                                              _messageController.text,
                                              (documentSnapshot["postId"]),
                                              widget.profileImage);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            // "",
                            timeago.format(
                              newPostDate,
                            ),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              fontFamily: "RedHatDisplay",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                
                },
              ),
            ]);
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          );
        });
  }

  Column carouselSlider() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            // autoPlay: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: 0,
            // enableInfiniteScroll: true,
            reverse: false,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
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
                  margin: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        InteractiveViewer(
                          transformationController: controller,
                          clipBehavior: Clip.none,
                          minScale: minScale,
                          maxScale: maxScale,
                          panEnabled: false,
                          onInteractionEnd: (details) {
                            resetAnimation();
                          },
                          child: CachedNetworkImage(
                            imageUrl: item,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    JumpingDotsProgressIndicator(
                              fontSize: 20.0,
                              color: Colors.blue,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
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
                            padding: const EdgeInsets.symmetric(
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
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
        // CarouselIndicator(
        //     imgList: imageList, controller: _controller, current: _current),
      ],
    );
  }

  void handleLiked(String postId, String userId, List postLiked) {
    DocumentReference likePost =
        FirebaseFirestore.instance.collection("post").doc(postId);
    if (postLiked.contains(userId)) {
      handleUnliked(postId, userId, postLiked);
    }
    postLiked.add(userId);
    likePost.update({'postLiked': postLiked});
    Fluttertoast.showToast(msg: "Post Liked");
    // postLiked.clear();
  }

  Future handleUnliked(String postId, String userId, List postLiked) async {
    DocumentReference likePost =
        FirebaseFirestore.instance.collection("post").doc(postId);
    postLiked.remove(userId);
    likePost.update({'postLiked': postLiked});
    // postLiked.clear();
    // Fluttertoast.showToast(msg: "Post Liked");
  }

  void handleSavedPost(String userId, String postId) {
    DocumentReference savePost =
        FirebaseFirestore.instance.collection("users").doc(userId);
    if (widget.postSaved.contains(postId)) {
      // handleUnliked(postId, userId, postLiked);
    }
    widget.postSaved.add(postId);
    savePost.update({'postSaved': widget.postSaved});
    Fluttertoast.showToast(msg: "Post Saved");
    // postLiked.clear();
  }

  void handleUnsavedPost(String userId, String postId) {
    DocumentReference savePost =
        FirebaseFirestore.instance.collection("users").doc(userId);
    if (widget.postSaved.contains(postId)) {
      // handleUnliked(postId, userId, postLiked);
    }
    widget.postSaved.remove(postId);
    savePost.update({'postSaved': widget.postSaved});
    Fluttertoast.showToast(msg: "Removed from saved list");
    // postLiked.clear();
  }

  void showBottomSheet(context, postImg, id, caption) => showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                title: const Text(
                  "Share",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                title: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                title: const Text(
                  "View Post",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return PostDetails(
                        id: id, postImg: postImg, caption: caption);
                  }));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                title: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));

  void shareModal(context) => showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.facebook,
                  color: Colors.white,
                ),
                title: const Text(
                  "Facebook",
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.devices_other,
                  color: Colors.white,
                ),
                title: const Text(
                  "Others",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
              const ListTile(
                leading: Icon(
                  Icons.copy,
                  color: Colors.white,
                ),
                title: Text(
                  "Copy",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ));
}


// class LikedBy extends StatelessWidget {
//   final String firstLikedBy;

//   const LikedBy({
//     Key? key,
//     required this.firstLikedBy,
//     required this.postLiked,
//   }) : super(key: key);

//   // final QueryDocumentSnapshot<Object?>? documentSnapshot;
//   final List postLiked;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(firstLikedBy)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot3) {
//           Map<String, dynamic> data =
//               snapshot3.data!.data() as Map<String, dynamic>;
//           if (postLiked.length < 2) {
//             return RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: data['name'],
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           if (postLiked.length > 2) {
//             return RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: data['name'],
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const TextSpan(
//                     text: " and ",
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const TextSpan(
//                     text: "Others",
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return Text("No post liked", style: TextStyle(color: Colors.white));
//         });
//   }
// }
