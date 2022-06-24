import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordpower_official_app/pages/widget/video_detail.dart';
import 'package:wordpower_official_app/pages/widget/video_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoCollection extends StatefulWidget {
  @override
  State<VideoCollection> createState() => _VideoCollectionState();
}

class _VideoCollectionState extends State<VideoCollection> {
  String currentVideoPlayingId = '';
  YoutubePlayerController _controller;
  int _rotation;

  final ScrollController _scrollController = ScrollController();

  runYoutubePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId:
          currentVideoPlayingId == '' ? 'OQRzJEb1xVc' : currentVideoPlayingId,
      flags: const YoutubePlayerFlags(
        enableCaption: true,
        autoPlay: false,
        // controlsVisibleAtStart: true,
        // hideControls: true,
      ),
    );
    //
  }

  @override
  void initState() {
    runYoutubePlayer();
    _rotation = 0;
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

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("youtube_videos")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Object>> documentSnapshot =
                  snapshot.data?.docs;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: const BoxDecoration(
                        // image: DecorationImage(
                        //     image: AssetImage("images/dadcover.jpg"),
                        //     fit: BoxFit.cover)),
                        ),
                    child: YoutubePlayer(
                      controller: _controller,
                      bottomActions: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return VideoScreen(
                                controller: _controller,
                                rotation: _rotation,
                              );
                            }));
                          },
                          icon: const Icon(Icons.fullscreen),
                        ),
                        RemainingDuration(),
                        CurrentPosition(),
                      ],
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blue,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.red,
                        handleColor: Colors.redAccent,
                        bufferedColor: Colors.yellow,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Recent videos",
                    style: TextStyle(
                        fontFamily: "RedHatDisplay",
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const ScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 150,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              changeVideo(documentSnapshot[index]['link']);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.4,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  decoration: BoxDecoration(
                                      // image: const DecorationImage(
                                      //   image: AssetImage("images/image1.jpg"),
                                      //   fit: BoxFit.cover,
                                      // ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: YoutubePlayer(
                                    controller: YoutubePlayerController(
                                      initialVideoId: documentSnapshot[index]
                                          ['link'],
                                      flags: const YoutubePlayerFlags(
                                        enableCaption: true,
                                        autoPlay: false,
                                        // controlsVisibleAtStart: true,
                                        hideControls: true,
                                      ),
                                    ),
                                    // controller: _controller,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 18,
                                    color: Colors.black54,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          documentSnapshot[index]['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: "RedHatDisplay",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        Text(
                                          documentSnapshot[index]
                                              ['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: "RedHatDisplay",
                                              fontSize: 5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
    );
  }

  changeVideo(videoId) async {
    setState(() {
      currentVideoPlayingId = videoId;
      _controller.load(currentVideoPlayingId);
      // _controller.reset();
    });
    // print(currentVideoPlayingId);
  }

  void updateData() {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      // int i = data.length+1;
      // data.add("Flutter Tutorial $i");
      timer.cancel();
      // setState(() {});
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return VideoCollection();
      }));
    });
  }
}
