import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordpower_official_app/pages/chat/chat_message.dart';
import 'package:wordpower_official_app/pages/chat/message_wall.dart';

class ChatHome extends StatefulWidget {
  ChatHome({Key key}) : super(key: key);
  final store = FirebaseFirestore.instance.collection("chat_messages");

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  void _addMessage(String value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await widget.store.add(
        {
          'author': user.displayName ?? 'Anonymous',
          'author_id': user.uid,
          'photo_url': user.photoURL ??
              'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
          'timestamp': Timestamp.now().millisecondsSinceEpoch,
          'value': value,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Chat with Apostle Freedman"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.store.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MessageWall(messages: snapshot.data.docs);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          MessageForm(
            onSubmit: _addMessage,
          ),
        ],
      ),
    );
  }
}
