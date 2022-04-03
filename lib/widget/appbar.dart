import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wordpower_official_app/pages/chat_apostle/chat_home_screen.dart';
import 'package:wordpower_official_app/theme/colors.dart';
import 'package:wordpower_official_app/widget/story/image_story.dart';

File singleImage;
final singlePicker = ImagePicker();
getAppBar(int pageIndex, context) {
  if (pageIndex == 0) {
    return AppBar(
      backgroundColor: appBarColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              final pickedImage =
                  await singlePicker.pickImage(source: (ImageSource.camera));
              if (pickedImage != null) {
                singleImage = File(pickedImage.path);
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ImageStory(image: singleImage);
                }));
              } else {
                Fluttertoast.showToast(msg: "No Image is selected");
              }
            },
            child: Icon(
              CupertinoIcons.camera,
              size: 25,
            ),
          ),
          // SvgPicture.asset("images/slr.svg"),
          Text(
            "Wordpower Ministry",
            style: GoogleFonts.josefinSans(
                textStyle: TextStyle(
              fontSize: 20,
              color: Colors.white,
              letterSpacing: .5,
              fontStyle: FontStyle.italic,
            )),
          ),
          // Icon(
          //   Icons.message_outlined,
          //   size: 30,
          // ),
          GestureDetector(
            child: Icon(
              CupertinoIcons.chat_bubble_2_fill,
              color: Colors.white,
              size: 25,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ChatHomeScreen();
              }));
            },
          ),
        ],
      ),
    );
  }
  // else if (pageIndex == 1) {
  //   null;
  // }
  else if (pageIndex == 1) {
    return AppBar(
      backgroundColor: Colors.red,
      title: Text("YouTube Channel"),
      automaticallyImplyLeading: false,
    );
  } else {
    return AppBar(
      backgroundColor: appBarColor,
      title: Text("Settings"),
      automaticallyImplyLeading: false,
    );
  }
  ;
}
