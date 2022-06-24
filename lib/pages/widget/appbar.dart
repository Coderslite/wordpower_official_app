import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wordpower_official_app/pages/chat_apostle/chat_home_screen.dart';
import 'package:wordpower_official_app/pages/widget/story/image_story.dart';
import 'package:wordpower_official_app/theme/colors.dart';

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
            child: const Icon(
              CupertinoIcons.camera,
              size: 25,
            ),
          ),
          // SvgPicture.asset("images/slr.svg"),
          const Text(
            "Wordpower Ministry",
            style: TextStyle(
              fontFamily: "RedHatDisplay",
            ),
            //  GoogleFonts.josefinSans(
            //   textStyle: TextStyle(
            //     fontSize: 20,
            //     color: Colors.white,
            //     letterSpacing: .5,
            //     fontStyle: FontStyle.italic,
            //   ),
          ),
          // Icon(
          //   Icons.message_outlined,
          //   size: 30,
          // ),
          GestureDetector(
            child: const Icon(
              CupertinoIcons.chat_bubble_2_fill,
              color: Colors.white,
              size: 25,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const ChatHomeScreen();
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
      backgroundColor: Colors.black,
      title: const Text(
        "Wordpower Tv",
        style: TextStyle(
          fontFamily: "RedHatDisplay",
        ),
      ),
      automaticallyImplyLeading: false,
    );
  } else {
    return AppBar(
      backgroundColor: appBarColor,
      title: const Text(
        "Settings",
        style: TextStyle(
          fontFamily: "RedHatDisplay",
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }
}
