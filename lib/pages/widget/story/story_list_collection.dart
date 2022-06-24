import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:wordpower_official_app/pages/widget/story/story_item.dart';

class StoryListCollection extends StatelessWidget {
  const StoryListCollection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("story_collection")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Something went wrong",
              style: TextStyle(color: Colors.white,
                                fontFamily: "RedHatDisplay",
              ),
            );
          }
          // if (snapshot.data == null) {
          //   return Text(
          //     "No stories",
          //     style: TextStyle(color: Colors.white,
          //                       fontFamily: "RedHatDisplay",
          //     ),
              
          //   );
          // }
          if (snapshot.hasData && snapshot.data != null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                snapshot.data.docs.length,
                (index) {
                  QueryDocumentSnapshot<Object> documentSnapshot =
                      snapshot.data.docs[index];
                  return StoryItem(
                    userId: documentSnapshot['userId'],
                  );
                },
              ),
            );
          }
          return JumpingDotsProgressIndicator();
        });
  }
}
