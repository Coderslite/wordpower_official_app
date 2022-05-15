import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordpower_official_app/constant/comment.dart';
import 'package:intl/intl.dart';

class CommentViewScreen extends StatefulWidget {
  final String postId;
  final String profileImage;
  const CommentViewScreen({Key key, this.postId, this.profileImage})
      : super(key: key);

  @override
  _CommentViewScreenState createState() => _CommentViewScreenState();
}

class _CommentViewScreenState extends State<CommentViewScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  String _message = "";
  List commentLike = [];

  User user = FirebaseAuth.instance.currentUser;

  handleAddComment(
      String comment, String userId, String postId, String profileImage) {
    DocumentReference commentReference =
        FirebaseFirestore.instance.collection("comments").doc();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    Map<String, dynamic> commentDetails = {
      "postId": postId,
      "comment": comment,
      "commenter": userId,
      "commentId": commentReference.id,
      "profileImage": profileImage,
      "date": formatted,
      "time": now.microsecondsSinceEpoch.toString(),
      "commentLike": [],
    };

    commentReference.set(commentDetails).then(
      (value) {
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
    return Dismissible(
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.of(context).pop(),
      key: const Key('key'),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Comments"),
          ),
          body: Column(children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('comments')
                      .where("postId", isEqualTo: widget.postId)
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong",
                          style: TextStyle(color: Colors.white));
                    }
                    if (!snapshot.hasData) {
                      return const Text(
                        "No Comment yet",
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    if (snapshot.hasData) {
                      List<QueryDocumentSnapshot<Object>> data =
                          snapshot.data?.docs;
                      // print(data);
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            commentLike = data[index]['commentLike'];
                            // print(commentLike);
                            return CommentList(
                                commenter: data[index]['commenter'].toString(),
                                message: data[index]['comment'].toString(),
                                date: data[index]['date'],
                                commentLike: commentLike,
                                userId: user.uid,
                                commentId: data[index]['commentId']);
                          });
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white24,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
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
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RawMaterialButton(
                    fillColor: _message == null || _message.isEmpty
                        ? Colors.grey
                        : Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      _message == null || _message.isEmpty
                          ? null
                          : handleAddComment(_messageController.text, user.uid,
                              widget.postId, widget.profileImage);
                    },
                    child: Icon(
                      CupertinoIcons.location_fill,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final String message;
  final String date;
  final String commenter;
  final List commentLike;
  final String userId;
  final String commentId;
  const CommentList({
    Key key,
    this.message,
    this.date,
    this.commenter,
    this.commentLike,
    this.userId,
    this.commentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(commenter)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 10),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(data['profileImage']),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width - 180,
                            child: RichText(
                              text: TextSpan(
                                text: data['name'],
                                children: [
                                  TextSpan(
                                      text: "  $message",
                                      style: TextStyle(
                                          color:
                                              Colors.white.withOpacity(0.7))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                date,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                commentLike.length <= 1
                                    ? commentLike.length.toString() + " Like"
                                    : commentLike.length.toString() + " Likes",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: commentLike.contains(userId)
                            ? IconButton(
                                onPressed: () {
                                  handleUnlikeComment(
                                      commentId, userId, commentLike);
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  handleLikeComment(
                                      commentId, userId, commentLike);
                                },
                                icon: Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                ),
                              ))
                  ],
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }

  void handleLikeComment(String commentId, String userId, List commentLike) {
    DocumentReference likePost =
        FirebaseFirestore.instance.collection("comments").doc(commentId);
    if (commentLike.contains(userId)) {
      handleUnlikeComment(commentId, userId, commentLike);
    }
    commentLike.add(userId);
    likePost.update({'commentLike': commentLike});
    Fluttertoast.showToast(msg: "Comment Liked");
    // postLiked.clear();
  }

  void handleUnlikeComment(String commentId, String userId, List commentLike) {
    DocumentReference likePost =
        FirebaseFirestore.instance.collection("comments").doc(commentId);
    if (commentLike.contains(userId)) {
      // handleUnliked(commentId, userId, commentLike);
    }
    commentLike.remove(userId);
    likePost.update({'commentLike': commentLike});
    Fluttertoast.showToast(msg: "Comment Liked");
    // postLiked.clear();
  }
}
