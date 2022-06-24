import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryDisplay extends StatefulWidget {
  final String userId;
  const StoryDisplay({Key key, this.userId}) : super(key: key);

  @override
  _StoryDisplayState createState() => _StoryDisplayState();
}

class _StoryDisplayState extends State<StoryDisplay> {
  List storyViewers;
  int i;
  int x;

  // List storyViewers = [];
  void addToStoryView(String docId) async {
    var upload = FirebaseFirestore.instance
        .collection("story_collection")
        .doc(widget.userId)
        .collection(widget.userId)
        .doc(docId)
        .update({'story_viewers': []}).whenComplete(() {
      print('updated');
    });
  }

  // void checkStatus() {
  //   for (x = 1; x < 5; x++) print(x);
  // }

  final StoryController controller = StoryController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onVerticalDragStart: (details) {
      //   shareModal(context);
      // },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Stories",
            style: TextStyle(color: Colors.white),
          ),
        ),
        // bottomNavigationBar: GestureDetector(
        //   onTap: () {
        //     shareModal(context);
        //   },
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         "5",
        //         style: TextStyle(color: Colors.white),
        //       ),
        //       SizedBox(
        //         width: 5,
        //       ),
        //       Icon(
        //         CupertinoIcons.eye,
        //         color: Colors.white,
        //       ),
        //     ],
        //   ),
        // ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("story_collection")
                .doc(widget.userId ?? null)
                .collection(widget.userId ?? null)
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.white),
                );
              }
              if (!snapshot.hasData) {
                return const Text(
                  "No data found",
                  style: TextStyle(color: Colors.white),
                );
              }
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot<Object>> data = snapshot.data.docs;

                return Center(
                  child: StoryView(
                    storyItems: [
                      for (i = 1; i <= snapshot.data.docs.length; i++)
                        data[i - 1]['type'] == 'text'
                            ? StoryItem.text(
                                title: data[i - 1]['text'],
                                backgroundColor: Color(data[i - 1]['color']))
                            : data[i - 1]['type'] == 'image'
                                ? StoryItem.pageImage(
                                    controller: controller,
                                    // requestHeaders: Map<String,dynamic>,
                                    // duration: Duration(seconds: 30),
                                    url: data[i - 1]['url'],
                                    caption: (data[i - 1]['caption']),
                                  )
                                : StoryItem.pageVideo((data[i - 1]['url']),
                                    controller: controller),
                    ],
                    // storyItems: [
                    //   if (data['type'] == 'text')
                    //     StoryItem.text(
                    //         title: data['text'], backgroundColor: Colors.blue)
                    // ],
                    // [
                    //   StoryItem.text(
                    //     title:
                    //         "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
                    //     backgroundColor: Colors.blue,
                    //     roundedTop: true,
                    //   ),
                    //   // StoryItem.inlineImage(
                    //   //   NetworkImage(
                    //   //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
                    //   //   caption: Text(
                    //   //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
                    //   //     style: TextStyle(
                    //   //       color: Colors.white,
                    //   //       backgroundColor: Colors.black54,
                    //   //       fontSize: 17,
                    //   //     ),
                    //   //   ),
                    //   // ),
                    //   StoryItem.inlineImage(
                    //     url:
                    //         "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                    //     controller: controller,
                    //     caption: Text(
                    //       "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         backgroundColor: Colors.black54,
                    //         fontSize: 17,
                    //       ),
                    //     ),
                    //   ),
                    //   StoryItem.inlineImage(
                    //     url:
                    //         "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                    //     controller: controller,
                    //     caption: Text(
                    //       "Hektas, sektas and skatad",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         backgroundColor: Colors.black54,
                    //         fontSize: 17,
                    //       ),
                    //     ),
                    //   )
                    // ],
                    onVerticalSwipeComplete: (e) {
                      return Text("HI");
                    },
                    onStoryShow: (s) {
                      // addToStoryView();
                      // for (int x = 1; x < data.length; x++) {
                      //   storyViewers = data[x - 1]['story_viewers'];
                      // }
                      // print(data[i - 1]['story_viewers']);
                    },
                    onComplete: () {
                      print("Completed a cycle");
                      Navigator.pop(context);
                    },
                    progressPosition: ProgressPosition.top,
                    repeat: false,
                    inline: true,
                    controller: controller,
                  ),
                );
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }

  shareModal(context) => showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "10",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Viewers",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("images/dad.JPG"),
                  ),
                  title: const Text(
                    "Ossai Abraham",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Divider(
                    color: Colors.white24,
                    endIndent: 5,
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("images/dad.JPG"),
                  ),
                  title: const Text(
                    "Aranmonise Michael",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Divider(
                    color: Colors.white24,
                    endIndent: 5,
                  ),
                ),
                const ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("images/dad.JPG"),
                  ),
                  title: Text(
                    "Gem Gift",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Divider(
                    color: Colors.white24,
                    endIndent: 5,
                  ),
                ),
              ],
            ),
          ));
}
