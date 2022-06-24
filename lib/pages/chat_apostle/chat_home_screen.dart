import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  bool senderChatTime = false;
  bool receiverChatTime = false;
  final TextEditingController messageController = TextEditingController();
  bool notNewConversation = false;
  bool status = true;
  bool typing = false;
  User user = FirebaseAuth.instance.currentUser;

  String _message = "";

  final ScrollController _scrollController = ScrollController();

  handleAddMessage(userId, userMessage) async {
    DocumentReference chatMessageParentId =
        FirebaseFirestore.instance.collection("chat_messages").doc(userId);
    DocumentReference chatMessage = FirebaseFirestore.instance
        .collection("chat_messages")
        .doc(userId)
        .collection(userId)
        .doc();

    Map<String, dynamic> conversation = {
      "time": DateTime.now().microsecondsSinceEpoch,
      "adminTypingStatus": false,
      "userTypingStatus": false,
      "userId": userId,
    };
    chatMessageParentId.set(conversation).whenComplete(() {
      Map<String, dynamic> message = {
        "message": userMessage,
        "user": true,
        "time": DateTime.now().microsecondsSinceEpoch,
      };

      chatMessage.set(message).whenComplete(() {
        setState(() {
          _message = "";
          messageController.clear();
        });
        print("Message sent");
        setState(() {
          // typing = false;
          _message = "";
          DocumentReference userConversation = FirebaseFirestore.instance
              .collection("chat_messages")
              .doc(user.uid);

          userConversation.update({
            "userTypingStatus": false,
          });
        });
      });

      // await Future.delayed(const Duration(milliseconds: 300));
      // SchedulerBinding.instance?.addPostFrameCallback((_) {
      //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //       duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Chat Now",
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomSheet: messageFieldForm(),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chat_messages")
                      .doc(user.uid)
                      .collection(user.uid)
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    Future.delayed(const Duration(milliseconds: 300));
                    SchedulerBinding.instance?.addPostFrameCallback((_) {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    });
                    if (snapshot.hasError) {
                      Text("Something went wrong");
                      notNewConversation = false;
                    }
                    if (snapshot.hasData) {
                      notNewConversation = true;
                      return Flexible(
                        child: ListView.builder(
                            physics: const ScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            shrinkWrap: true,
                            controller: _scrollController,
                            // scrollDirection: Axis.vertical,
                            primary: false,
                            // keyboardDismissBehavior:
                            //     ScrollViewKeyboardDismissBehavior.onDrag,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot<Object> documentSnapshot =
                                  snapshot.data.docs[index];
                              var currentDate =
                                  DateTime.fromMicrosecondsSinceEpoch(
                                      documentSnapshot["time"]);
                              var newDate = DateFormat('MM/dd/yyyy,hh:mm a')
                                  .format(currentDate);
                              DateTime newPostDate =
                                  DateFormat('MM/dd/yyyy,hh:mm a')
                                      .parse(newDate);
                              return documentSnapshot["user"] == true
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          senderChatTime = !senderChatTime;
                                          receiverChatTime = false;
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          senderMessage(
                                              documentSnapshot["message"]),
                                          senderChatTime
                                              ? Text(
                                                  timeago.format(
                                                    newPostDate,
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text(""),
                                        ],
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          receiverChatTime = !receiverChatTime;
                                          senderChatTime = false;
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          receiverMessage(
                                              documentSnapshot["message"]),
                                          receiverChatTime
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 58.0),
                                                  child: Text(
                                                    timeago.format(
                                                      newPostDate,
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Text(""),
                                        ],
                                      ),
                                    );
                            }),
                      );
                    }
                    notNewConversation = false;
                    return CircularProgressIndicator();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Container receiverMessage(message) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/wordpower-ministry-app.appspot.com/o/logo%2Flogo.png?alt=media&token=4e35bf75-17c6-455b-bedf-46c2dfb4dfb5"),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: 300,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container senderMessage(message) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: 300,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.zero,
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container messageFieldForm() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SvgPicture.asset("assets/svgs/mic.svg"),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextField(
              // controller: _controller,
              style: TextStyle(color: Colors.white),
              minLines: 1,
              maxLines: 5,
              onChanged: (value) {
                value.isNotEmpty
                    ? setState(() {
                        // typing = true;
                        _message = value;
                        DocumentReference userConversation = FirebaseFirestore
                            .instance
                            .collection("chat_messages")
                            .doc(user.uid);

                        userConversation.update({
                          "userTypingStatus": true,
                        });
                      })
                    : setState(() {
                        // typing = false;
                        _message = "";
                        DocumentReference userConversation = FirebaseFirestore
                            .instance
                            .collection("chat_messages")
                            .doc(user.uid);

                        userConversation.update({
                          "userTypingStatus": false,
                        });
                      });
              },
              controller: messageController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 15.67),
                  suffixIcon: SvgPicture.asset("assets/svg/emoji.svg"),
                  hintText: "Messages...",
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w200, color: Color(0xFF7C7C7C))),
              scrollPadding: EdgeInsets.all(0),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          // RawMaterialButton(
          //   fillColor: _message.isNotEmpty ? Colors.blue : Colors.grey,
          //   shape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //   onPressed: () {
          //     _message.isNotEmpty || _message != ""
          //         ? handleAddMessage(user.uid, messageController.text)
          //         : null;
          //   },
          //   child: Icon(
          //     CupertinoIcons.location_fill,
          //     color: Colors.white,
          //   ),
          // ),

          GestureDetector(
              onTap: () {
                _message.isNotEmpty || _message != ""
                    ? handleAddMessage(user.uid, messageController.text)
                    : null;
              },
              child: Icon(Icons.add, color: Colors.white24)),
        ],
      ),
    );
  }
}

class typingStatus extends StatelessWidget {
  final String userId;
  const typingStatus({
    Key key,
    this.widget,
    this.userId,
  }) : super(key: key);

  final ChatHomeScreen widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat_messages")
            .doc(userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> typingstatus) {
          print(typingstatus.data.exists);
          if (typingstatus.hasError) {
            return Text("");
          }
          if (typingstatus.data.exists == false) {
            return Text("");
          }
          if (typingstatus.hasData) {
            Map<String, dynamic> data =
                typingstatus.data.data() as Map<String, dynamic>;
            return data['adminTypingStatus'] == true
                ? const Text(
                    " typing...",
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    "",
                  );
          }
          return Text("");
        });
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
