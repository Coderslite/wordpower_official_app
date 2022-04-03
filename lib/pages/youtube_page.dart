import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordpower_official_app/pages/youtube_full_screen.dart';

class YoutubeView extends StatefulWidget {
  const YoutubeView({Key key}) : super(key: key);

  @override
  _YoutubeViewState createState() => _YoutubeViewState();
}

class _YoutubeViewState extends State<YoutubeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Flexible(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("youtube_videos")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text(
                          "Something went wrong",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "RedHatDisplay",
                          ),
                        );
                      } else if (snapshot.hasData || snapshot.data != null) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              QueryDocumentSnapshot<Object> documentSnapshot =
                                  snapshot.data?.docs[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return YoutubeFullScreen(
                                      item: documentSnapshot["link"],
                                    );
                                  }));
                                },
                                child: ListTile(
                                  title: Text(
                                    documentSnapshot["name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "RedHatDisplay",
                                    ),
                                  ),
                                  subtitle: Text(
                                    documentSnapshot["description"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "RedHatDisplay",
                                    ),
                                  ),
                                  autofocus: false,
                                  trailing: Icon(
                                    Icons.play_arrow_outlined,
                                    color: Colors.white,
                                  ),
                                  leading: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "RedHatDisplay",
                                    ),
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      );
                    })),
          ),
        ],
      ),
    );
  }
}
