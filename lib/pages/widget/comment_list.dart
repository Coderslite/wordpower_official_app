import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordpower_official_app/pages/widget/comment_view.dart';
import 'package:wordpower_official_app/pages/widget/post_screen.dart';

class commentList extends StatelessWidget {
  final QueryDocumentSnapshot<Object> documentSnapshot;
  final PostItem widget;
  const commentList({
    Key key,
    this.documentSnapshot,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: GestureDetector(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("comments")
                .where('postId', isEqualTo: documentSnapshot["postId"])
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  "Something went wrong",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RedHatDisplay",
                  ),
                );
              }
              if (snapshot.data == null) {
                return Text(
                  "No Comment Yet",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: "RedHatDisplay",
                  ),
                );
              }

              if (snapshot.hasData) {
                List<QueryDocumentSnapshot<Map>> data = snapshot.data.docs;

                if (data.length < 2) {
                  return Text(
                    data.length.toString() + " comment",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "RedHatDisplay",
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
                      fontFamily: "RedHatDisplay",
                    ),
                  );
                }
              }
              return const Text("Loading.....");
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
