import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AdminChatScreen extends StatefulWidget {
  final String userId;
  const AdminChatScreen({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController messageController = TextEditingController();
  bool sender = false;
  bool status = true;
  bool typing = false;
  User user = FirebaseAuth.instance.currentUser;

  String _message = "";

  final ScrollController _scrollController = ScrollController();

  handleAddMessage(userId, userMessage) async {
    DocumentReference chatMessage = FirebaseFirestore.instance
        .collection("chat_messages")
        .doc(userId)
        .collection(userId)
        .doc();

    Map<String, dynamic> message = {
      "message": userMessage,
      "time": DateTime.now().microsecondsSinceEpoch,
      "user": false,
    };

    chatMessage.set(message).whenComplete(() {
      setState(() {
        _message = "";
        messageController.clear();
      });
      print("Message sent");
    });

    await Future.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance?.addPostFrameCallback((_) {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
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
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      typingStatus(widget: widget),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chat_messages")
                          .doc(widget.userId)
                          .collection(widget.userId)
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
                        }
                        if (snapshot.hasData) {
                          return Flexible(
                            child: ListView.builder(
                                physics: const ScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                controller: _scrollController,
                                // scrollDirection: Axis.vertical,
                                // primary: false,
                                // keyboardDismissBehavior:
                                //     ScrollViewKeyboardDismissBehavior.onDrag,
                                itemBuilder: (context, index) {
                                  QueryDocumentSnapshot<Object>
                                      documentSnapshot =
                                      snapshot.data.docs[index];
                                  return documentSnapshot["user"] == false
                                      ? senderMessage(
                                          documentSnapshot["message"])
                                      : receiverMessage(
                                          documentSnapshot["message"]);
                                }),
                          );
                        }
                        return CircularProgressIndicator();
                      }),
                ],
              ),
            ),
            messageFieldForm(),
          ],
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
            backgroundImage: AssetImage("images/dad.JPG"),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              // controller: _controller,
              onSubmitted: (value) {
                _message.isNotEmpty || _message != ""
                    ? handleAddMessage(widget.userId, messageController.text)
                    : null;
              },
              textInputAction: TextInputAction.send,
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
                            .doc(widget.userId);

                        userConversation.update({
                          "adminTypingStatus": true,
                        });
                      })
                    : setState(() {
                        // typing = false;
                        _message = "";
                        DocumentReference userConversation = FirebaseFirestore
                            .instance
                            .collection("chat_messages")
                            .doc(widget.userId);

                        userConversation.update({
                          "adminTypingStatus": false,
                        });
                      });
              },
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Type a Message",
                hintStyle: TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          RawMaterialButton(
            fillColor: _message.isNotEmpty ? Colors.blue : Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              _message.isNotEmpty || _message != ""
                  ? handleAddMessage(widget.userId, messageController.text)
                  : null;
            },
            child: Icon(
              CupertinoIcons.location_fill,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class typingStatus extends StatelessWidget {
  const typingStatus({
    Key key,
    this.widget,
  }) : super(key: key);

  final AdminChatScreen widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat_messages")
            .doc(widget.userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> typingstatus) {
          Map<String, dynamic> data =
              typingstatus.data.data() as Map<String, dynamic>;
          return data['userTypingStatus'] == true
              ? const Text(
                  "typing...",
                  style: TextStyle(color: Colors.white),
                )
              : Row(
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      maxRadius: 5,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Online",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                );
        });
  }
}
