import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wordpower_official_app/pages/home_page.dart';
import 'package:wordpower_official_app/pages/widget/appbar.dart';
import 'package:wordpower_official_app/pages/widget/settings.dart';
import 'package:wordpower_official_app/pages/widget/video_collection.dart';
import 'package:wordpower_official_app/pages/youtube_page.dart';
import 'package:wordpower_official_app/theme/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  File singleImage;
  final singlePicker = ImagePicker();

    YoutubePlayerController _controller;
    runYoutubePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: 'OQRzJEb1xVc',
      flags: const YoutubePlayerFlags(
        enableCaption: true,
        autoPlay: false,
        // controlsVisibleAtStart: true,
        // hideControls: true,
      ),
    );
    //
    
  @override
  void initState() {
    runYoutubePlayer();
    super.initState();
  }

      @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    // _idController.dispose();
    // _seekToController.dispose();
    super.dispose();
  }

  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: black,
      appBar: getAppBar(
        pageIndex,
        context,
      ),
      bottomNavigationBar: getFooter(size),
      body: getBody(),
    );
  }

  getBody() {
    List<Widget> Pages = [
      const HomePage(),
      // SearchPage(),
      // const YoutubeView(),
      VideoCollection(),
      // Center(
      //   child: Text(
      //     "Youtube",
      //     style: TextStyle(
      //         color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      // ),
      const Setting(),
    ];
    return IndexedStack(
      index: pageIndex,
      children: Pages,
    );
  }

  getFooter(size) {
    List bottomItems = [
      pageIndex == 0 ? "images/home_icon_active.svg" : "images/home_icon.svg",
      pageIndex == 1 ? "images/love_icon_active.svg" : "images/love_icon.svg",
      pageIndex == 2
          ? "images/account_icon_active.svg"
          : "images/account_icon.svg",
    ];

    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: appBarColor,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, left: 20, bottom: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            bottomItems.length,
            (index) {
              return InkWell(
                onTap: () {
                  selectedTab(index);
                },
                child: Container(
                  width: size.width / 6,
                  child: SvgPicture.asset(
                    bottomItems[index],
                    color: Colors.white,
                    width: 25,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
