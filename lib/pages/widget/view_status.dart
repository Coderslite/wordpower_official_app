import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class ViewStatus extends StatefulWidget {
  const ViewStatus({Key key}) : super(key: key);

  @override
  State<ViewStatus> createState() => _ViewStatusState();
}

class _ViewStatusState extends State<ViewStatus> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("View Status"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("story_collection")
              .doc(user.uid)
              .collection(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                "Something went wrong",
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.data == null) {
              return const Center(
                child: Text(
                  "No Story Yet",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              return Column(children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var documentSnapshot = snapshot.data.docs[index];
                      // print(documentSnapshot.id);
                      // var dateInt = int.parse(documentSnapshot["time"]);
                      // print(dateInt);
                      var currentDate = DateTime.fromMicrosecondsSinceEpoch(
                          documentSnapshot["time"]);
                      var newDate =
                          DateFormat('MM/dd/yyyy,hh:mm a').format(currentDate);
                      DateTime newPostDate =
                          DateFormat('MM/dd/yyyy,hh:mm a').parse(newDate);
                      return Dismissible(
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        key: UniqueKey(),
                        onDismissed: (direction) async {
                          snapshot.data.docs.length > 1
                              ? handleDelete(documentSnapshot.id)
                              : handleDeleteDoc(documentSnapshot.id);
                        },
                        child: ListTile(
                          leading: documentSnapshot['type'] == 'text'
                              ? CircleAvatar(
                                  backgroundColor:
                                      Color(documentSnapshot['color']),
                                  child: Text(
                                    documentSnapshot['text'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(documentSnapshot['url']),
                                ),
                          title: Text(
                            // "",
                            timeago.format(
                              newPostDate,
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "status " + (index + 1).toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          // subtitle: ,
                        ),
                      );
                    }),
              ]);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  handleDelete(id) async {
    FirebaseFirestore.instance
        .collection("story_collection")
        .doc(user.uid)
        .collection(user.uid)
        .doc(id)
        .delete()
        .then((value) =>
            Fluttertoast.showToast(msg: 'Story Deleted Successfully'));
  }

  handleDeleteDoc(id) {
    FirebaseFirestore.instance
        .collection("story_collection")
        .doc(user.uid)
        .collection(user.uid)
        .doc(id)
        .delete()
        .whenComplete(() {
      FirebaseFirestore.instance
          .collection("story_collection")
          .doc(user.uid)
          .delete()
          .then((value) =>
              Fluttertoast.showToast(msg: 'Story Deleted Successfully'));
    });
  }
}
