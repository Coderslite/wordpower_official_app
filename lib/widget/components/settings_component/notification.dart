import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontFamily: "RedHatDisplay",
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: const ListTile(
                  title: Text(
                    "Push Notification",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RedHatDisplay",
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const ListTile(
                  title: Text(
                    "Live Video and Call",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RedHatDisplay",
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const ListTile(
                  title: Text(
                    "Pause All",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RedHatDisplay",
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const ListTile(
                  title: Text(
                    "Email and Sms",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RedHatDisplay",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
