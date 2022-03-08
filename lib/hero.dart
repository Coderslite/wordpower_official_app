import 'package:flutter/material.dart';

class HeroApp extends StatelessWidget {
  const HeroApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BottomSheet"),
      ),
      body: ElevatedButton(
          child: Text("Click me"),
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: Colors.black,
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          title: Text(
                            "share",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          title: Text(
                            "save",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          title: Text(
                            "View Post",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ));
          }),
    );
  }
}
