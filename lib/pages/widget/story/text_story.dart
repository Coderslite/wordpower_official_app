import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordpower_official_app/pages/root_app.dart';

class TextStory extends StatefulWidget {
  const TextStory({Key key}) : super(key: key);

  @override
  _TextStoryState createState() => _TextStoryState();
}

class _TextStoryState extends State<TextStory> {
  Color backgroundColor = Color(4280391411);
  String color;

  User user = FirebaseAuth.instance.currentUser;
  final TextEditingController _message = TextEditingController();

  void handleTextStory(message, color) {
    DocumentReference storyCreation =
        FirebaseFirestore.instance.collection("story_collection").doc(user.uid);
    DocumentReference storyCollection = FirebaseFirestore.instance
        .collection("story_collection")
        .doc(user.uid)
        .collection(user.uid)
        .doc();
    Map<String, dynamic> storyCreate = {
      "userId": user.uid,
      "time": DateTime.now().microsecondsSinceEpoch,
    };
    storyCreation.set(storyCreate).whenComplete(() {
      Map<String, dynamic> textStory = {
        "text": message,
        "time": DateTime.now().microsecondsSinceEpoch,
        "color": color,
        "type": "text",
        "story_viewers": [],
        "storyId": storyCollection.id,
      };
      storyCollection.set(textStory).whenComplete(() {
        _message.clear();
        Fluttertoast.showToast(msg: "upload story successful").then(
            (value) => Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return RootApp();
                })));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: GestureDetector(
        onTap: () {
          handleTextStory(_message.text, backgroundColor.value.toInt());
        },
        child: const CircleAvatar(
          minRadius: 2,
          maxRadius: 30,
          backgroundColor: Colors.blue,
          child: Icon(
            // CupertinoIcons.arrow_right,
            Icons.send_outlined,
            color: Colors.white,
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Story Upload",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            color: backgroundColor ?? Colors.blue,
            child: Center(
              child: TextField(
                minLines: 1,
                maxLines: 10,
                textAlign: TextAlign.center,
                autocorrect: true,
                autofocus: true,
                controller: _message,
                style: const TextStyle(fontSize: 25, color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: "Type a status",
                  hintStyle: TextStyle(color: Colors.white30),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ),
        colorScroll()
      ]),
    );
  }

  SingleChildScrollView colorScroll() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.red;
                color = 'red';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.red,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       backgroundColor = Colors.redAccent;
          //     });
          //   },
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     color: Colors.redAccent,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.blue;
                color = 'blue';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.blue,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.black;
                color = 'black';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.blueGrey;
                color = 'blueGrey';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.blueGrey,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.brown;
                color = 'brown';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.brown,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.teal;
                color = 'teal';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.teal,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       backgroundColor = Colors.green;
          //     });
          //   },
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     color: Colors.green,
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       backgroundColor = Colors.greenAccent;
          //     });
          //   },
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     color: Colors.greenAccent,
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       backgroundColor = Colors.lightGreen;
          //     });
          //   },
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     color: Colors.lightGreen,
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       backgroundColor = Colors.lightGreenAccent;
          //     });
          //   },
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     color: Colors.lightGreenAccent,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.pink;
                color = 'pink';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.pink,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       backgroundColor = Colors.pinkAccent;
          //     });
          //   },
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     color: Colors.pinkAccent,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.purple;
                color = 'purple';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.purple,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       backgroundColor = Colors.purpleAccent;
          //     });
          //   },
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     color: Colors.purpleAccent,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.deepPurple;
                color = 'deepPurple';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.deepPurple,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.deepPurpleAccent;
                color = 'deepPurpleAccent';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.deepPurpleAccent,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       backgroundColor = Colors.white;
          //     });
          //   },
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     color: Colors.white,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.orange;
                color = 'orange';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.orange,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       backgroundColor = Colors.orangeAccent;
          //     });
          //   },
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     color: Colors.orangeAccent,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.deepOrange;
                color = 'deepOrange';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.deepOrange,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                backgroundColor = Colors.deepOrangeAccent;
                color = 'deepOrangeAccent';
              });
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.deepOrangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
