import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:wordpower_official_app/pages/widget/comment_list.dart';
import 'package:wordpower_official_app/pages/widget/comment_view.dart';
import 'package:wordpower_official_app/theme/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostScreenSingle extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final int index;
  final List imageList;
  final String profileImage;
  final List postSaved;
  final List postLiked;
  final int descriptionLength;
  final DateTime newPostDate;
  const PostScreenSingle(
      {Key key,
      this.documentSnapshot,
      this.index,
      this.imageList,
      this.profileImage,
      this.postSaved,
      this.postLiked,
      this.descriptionLength, this.newPostDate})
      : super(key: key);

  @override
  State<PostScreenSingle> createState() => _PostScreenSingleState();
}

class _PostScreenSingleState extends State<PostScreenSingle>
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

  User user = FirebaseAuth.instance.currentUser;

  final CarouselController _controller = CarouselController();
  int _current = 0;

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                    // showBottomSheet(
                    //     context,
                    //     (widget.documentSnapshot != null)
                    //         ? (widget.documentSnapshot["imageUrl"]
                    //             [widget.index])
                    //         : "",
                    //     (widget.documentSnapshot != null)
                    //         ? (widget.documentSnapshot["postId"][widget.index])
                    //         : "",
                    //     (widget.documentSnapshot != null)
                    //         ? (widget.documentSnapshot["description"]
                    //             [widget.index])
                    //         : "");
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
                child: widget.imageList.length <= 1
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
                          imageUrl: widget.imageList[0],
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
                handleLiked((widget.documentSnapshot["postId"]), user.uid,
                    widget.postLiked);
              },
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    widget.postLiked.contains(user.uid)
                        ? IconButton(
                            onPressed: () {
                              handleUnliked((widget.documentSnapshot["postId"]),
                                  user.uid, widget.postLiked);
                            },
                            icon: const Icon(
                              CupertinoIcons.heart_solid,
                              size: 27,
                              color: Colors.red,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              handleLiked((widget.documentSnapshot["postId"]),
                                  user.uid, widget.postLiked);
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
                                postId: widget.documentSnapshot["postId"],
                                profileImage: widget.profileImage);
                          }));
                        },
                        child: const Icon(CupertinoIcons.chat_bubble,
                            size: 27, color: Colors.white)),
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
                widget.postSaved.contains(widget.documentSnapshot['postId'])
                    ? IconButton(
                        onPressed: () {
                          handleUnsavedPost(
                              user.uid, widget.documentSnapshot['postId']);
                        },
                        icon: const Icon(
                          CupertinoIcons.bookmark_solid,
                          color: Colors.red,
                          size: 25,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          handleSavedPost(
                              user.uid, widget.documentSnapshot['postId']);
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
            child: widget.postLiked.length < 2
                ? Text(
                    widget.postLiked.length.toString() + " like",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "RedHatDisplay",
                    ),
                  )
                : Text(
                    widget.postLiked.length.toString() + " likes",
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
              child: widget.postLiked.isEmpty
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.descriptionLength > 2
                            ? Text(
                                (widget.documentSnapshot["description"]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "RedHatDisplay",
                                ),
                              )
                            : Text(
                                (widget.documentSnapshot["description"]),
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
          // commentList(documentSnapshot: widget.documentSnapshot, widget: widget),
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
                              image: NetworkImage(widget.profileImage),
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
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Add your comments",
                          hintStyle: const TextStyle(
                            color: Colors.white54,
                            fontFamily: "RedHatDisplay",
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(10),
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
                              color: Colors.white.withOpacity(0.3), size: 18)
                          : const Icon(Icons.add_circle,
                              color: Colors.blue, size: 18),
                      onPressed: () {
                        _message == null || _message.isEmpty
                            ? null
                            : handleAddComment(
                                _messageController.text,
                                (widget.documentSnapshot["postId"]),
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
                widget.newPostDate,
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
          items: widget.imageList
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
          children: widget.imageList.asMap().entries.map((entry) {
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
