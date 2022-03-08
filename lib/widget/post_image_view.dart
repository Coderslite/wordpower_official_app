import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:wordpower_official_app/theme/colors.dart';

class DetailScreen extends StatelessWidget {
  final String postImg;
  final String id;
  const DetailScreen({Key key, this.postImg, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.none,
      key: const Key('key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(LineIcons.verticalEllipsis, color: white),
              onPressed: () {
                showBottomSheet(context);
              },
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Dismissible(
            direction: DismissDirection.down,
            key: const Key('key'),
            onDismissed: (_) => Navigator.of(context).pop(),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: InteractiveViewer(
                minScale: 0.2,
                maxScale: 10.0,
                // boundaryMargin: const EdgeInsets.all(double.infinity),
                // constrained: false,
                child: Image.asset(postImg),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet(context) => showModalBottomSheet(
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
                  "Share",
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
                  "Save",
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
              ListTile(
                leading: Icon(
                  Icons.copy,
                  color: Colors.white,
                ),
                title: Text(
                  "Copy Link",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
            ],
          ));
}
