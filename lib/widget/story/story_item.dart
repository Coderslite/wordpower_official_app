import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:wordpower_official_app/theme/colors.dart';
import 'package:wordpower_official_app/widget/story/story_display.dart';

class StoryItem extends StatelessWidget {
  final String userId;
  const StoryItem({
    Key key,
    this.userId,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20,
        bottom: 10,
      ),
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("story_collection")
              .doc(userId)
              .collection(userId)
              .orderBy("time", descending: false)
              .get(),
          builder: (context, storysnapshot) {
            List<QueryDocumentSnapshot<Object>> data = storysnapshot.data.docs;
            int storyLength = storysnapshot.data.docs.length;
            if (storysnapshot.hasError) {
              return const Text(
                "Something went wrong",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "RedHatDisplay",
                ),
              );
            }
            if (!storysnapshot.hasData) {
              return const Text(
                "No stories",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "RedHatDisplay",
                ),
              );
            }
            if (storysnapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return StoryDisplay(userId: userId);
                      },
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: storyBorderColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: data[storyLength - 1]['type'] == 'text'
                            ? Stack(children: [
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      shape: BoxShape.circle,
                                      color: Color(
                                          data[storyLength - 1]['color'])),
                                  child: Center(
                                      child: Text(
                                    data[storyLength - 1]['text'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "RedHatDisplay",
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 19,
                                    height: 19,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Color(data[storyLength - 1]['color']),
                                    ),
                                    child: Center(
                                      child: Text(
                                        storyLength.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "RedHatDisplay",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])
                            : Stack(
                                children: [
                                  Container(
                                    width: 65,
                                    height: 65,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: black,
                                      ),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              data[storyLength - 1]['url']),
                                          fit: BoxFit.cover),
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
                                        color: Color(
                                          0xff2196f3,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          storyLength.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "RedHatDisplay",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(userId)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text(
                              "Something went wrong",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "RedHatDisplay",
                              ),
                            );
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            Map<String, dynamic> data =
                                snapshot.data.data() as Map<String, dynamic>;
                            return SizedBox(
                              child: Text(
                                data['name'] ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: white,
                                  fontFamily: "RedHatDisplay",
                                ),
                              ),
                            );
                          }
                          return JumpingDotsProgressIndicator();
                        }),
                  ],
                ),
              );
            }
            return const Text(
              "loading",
              style: TextStyle(fontFamily: "RedHatDisplay"),
            );
          }),
    );
  }
}
