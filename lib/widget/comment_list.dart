import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordpower_official_app/widget/comment_view.dart';
import 'package:wordpower_official_app/widget/post_screen.dart';

class commentList extends StatelessWidget {
  const commentList({
    Key key,
    this.documentSnapshot,
    this.widget,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object> documentSnapshot;
  final PostItem widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: GestureDetector(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("comments")
                .where('postId', isEqualTo: (documentSnapshot["postId"] ?? ""))
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
              List<QueryDocumentSnapshot<Map>> data = snapshot.data.docs;
              if (snapshot.hasError) {
                return Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.white),
                );
              }
              if (snapshot.hasData) {
                if (data.length < 2) {
                  return Text(
                    data.length.toString() + " comment",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                if (data.length > 1) {
                  return Text(
                    data.length.toString() + " comments",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                if (data.isEmpty) {
                  return Text(
                    "No Comment Yet",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              }
              return CircularProgressIndicator();
            }),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return CommentViewScreen(
                  postId: documentSnapshot["postId"],
                  profileImage: widget.profileImage,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
