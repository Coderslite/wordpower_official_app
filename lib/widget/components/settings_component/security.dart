import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Security"),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login Security",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    "Password",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.vpn_key_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    "Login Activity",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.gps_fixed,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    "Email",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.email_outlined,
                    color: Colors.white,
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
