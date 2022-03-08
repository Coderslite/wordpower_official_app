import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_message_other.dart';

class MessageWall extends StatelessWidget {
  final List<QueryDocumentSnapshot> messages;
  const MessageWall({Key key, this.messages}) : super(key: key);

  bool shouldDisplayAvatar(int idx) {
    if (idx == 0) return true;
    final previoudId =
        (messages[idx - 1].data() as Map<String, dynamic>)['author_id'];
    final authorId =
        (messages[idx].data() as Map<String, dynamic>)['author_id'];
    return authorId != previoudId;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          // messages[index].data();
          // messages[index]['value'];
          return ChatMessageOther(
            index: index,
            data: (messages[index].data() as Map<String, dynamic>),
            showAvatar: shouldDisplayAvatar(index),
          );
        });
  }
}
