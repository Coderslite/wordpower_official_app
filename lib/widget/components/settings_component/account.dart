import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:wordpower_official_app/pages/login/login_screen.dart';
import 'package:wordpower_official_app/widget/components/settings_component/account/personal_information.dart';
import 'package:wordpower_official_app/widget/components/settings_component/account/saved_post.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return const PersonalInformation();
                }));
              },
              child: const ListTile(
                title: Text(
                  "Personal Information",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const ListTile(
                title: Text(
                  "Your Activity",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SavedPostList();
                }));
              },
              child: const ListTile(
                title: Text(
                  "Saved",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const ListTile(
                title: Text(
                  "Post you have liked",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const ListTile(
                title: Text(
                  "Brand Content",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(context);
              },
              child: const ListTile(
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDialog(context) async {
    return await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: const Text("Logout ?"),
      content: const Text("Hi, please confirm your login out"),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              _logoutUser();
            },
            child: const Text(
              "yes",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
            ),
          ),
        ),
      ],
    ).show(context);
  }

  void _logoutUser() async {
    await _auth
        .signOut()
        .then(
          (e) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) {
                return const LoginScreen();
              },
            ),
          ),
        )
        .catchError((e) {
      Fluttertoast.showToast(msg: e.message);
    });
  }
}
