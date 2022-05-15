import 'package:flutter/material.dart';
import 'package:wordpower_official_app/theme/colors.dart';
import 'package:wordpower_official_app/widget/components/settings_component/account.dart';
import 'package:wordpower_official_app/widget/components/settings_component/notification.dart';
import 'package:wordpower_official_app/widget/components/settings_component/security.dart';
import 'package:wordpower_official_app/widget/video_collection.dart';

class Setting extends StatelessWidget {
  const Setting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                width: size.width - 30,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: textFieldBackground,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "search",
                    hintStyle: TextStyle(color: white.withOpacity(0.3)),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: white.withOpacity(0.3),
                    ),
                  ),
                  style: TextStyle(
                    color: white.withOpacity(0.3),
                  ),
                  cursorColor: white.withOpacity(0.3),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return const NotificationScreen();
                              },
                            ),
                          );
                        },
                        child: const ListTile(
                          title: Text(
                            "Notificaton",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RedHatDisplay",
                            ),
                          ),
                          leading: Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          title: Text(
                            "Privacy",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RedHatDisplay",
                            ),
                          ),
                          leading: Icon(Icons.verified_outlined,
                              color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return const SecurityScreen();
                          }));
                        },
                        child: const ListTile(
                          title: Text(
                            "Security",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RedHatDisplay",
                            ),
                          ),
                          leading: Icon(Icons.security_outlined,
                              color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return const AccountScreen();
                          }));
                        },
                        child: const ListTile(
                          title: Text(
                            "Account",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RedHatDisplay",
                            ),
                          ),
                          leading: Icon(Icons.person_outline_rounded,
                              color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          title: Text(
                            "Help",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RedHatDisplay",
                            ),
                          ),
                          leading: Icon(Icons.help_outline_rounded,
                              color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          title: Text(
                            "About",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RedHatDisplay",
                            ),
                          ),
                          leading: Icon(Icons.info_outline_rounded,
                              color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return VideoCollection();
                          }));
                        },
                        child: const ListTile(
                          title: Text(
                            "Video Player",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RedHatDisplay",
                            ),
                          ),
                          leading: Icon(Icons.video_collection_sharp,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
