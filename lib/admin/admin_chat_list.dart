import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordpower_official_app/admin/admin_chat_user.dart';

class AdminChatList extends StatefulWidget {
  const AdminChatList({Key key}) : super(key: key);

  @override
  _AdminChatListState createState() => _AdminChatListState();
}

class _AdminChatListState extends State<AdminChatList> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chat_messages")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            const Text(
              "Something went wrong",
              style: TextStyle(color: Colors.white),
            );
          }
          // if (snapshot.data!.size == 0) {
          //   Text(
          //     "Something went wrong",
          //     style: TextStyle(color: Colors.white),
          //   );
          // }
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Object>> data = snapshot.data?.docs;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  // print(data?[index]['time']);
                  return userInfo(
                    userId: data[index]['userId'].toString(),
                  );
                  // return UserDetails(userId: (data?[index]['time']));
                });
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class userInfo extends StatelessWidget {
  final String userId;
  const userInfo({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text(
                "Something went wrong",
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasData || snapshot.data != null) {
              Map<String, dynamic> data =
                  snapshot.data.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return AdminChatScreen(
                          userId: userId,
                        );
                      },
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    data['name'],
                    style: TextStyle(color: Colors.white),
                  ),

                  // subtitle: ,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data['profileImage']),
                  ),
                  // isThreeLine: true,
                  trailing: Text(
                    "2",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}

class UserDetails extends StatelessWidget {
  final String userId;
  const UserDetails({
    Key key,
    this.userId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("users").doc(userId).get(),
        builder: (context, AsyncSnapshot snapshot5) {
          if (snapshot5.hasError) {
            return Text(
              "Something went wrong",
              style: TextStyle(color: Colors.white),
            );
          }
          if (snapshot5.hasData) {
            Map data = snapshot5.data?.data();
            print(data['profileImage']);
            return ListTile(
              title: Text(
                "",
                style: TextStyle(color: Colors.white),
              ),

              // subtitle: ,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(""),
              ),
              // isThreeLine: true,
              trailing: Text(
                "2",
                style: TextStyle(color: Colors.blue),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
