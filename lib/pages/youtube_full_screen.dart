import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeFullScreen extends StatefulWidget {
  final String item;
  const YoutubeFullScreen({Key key, this.item}) : super(key: key);

  @override
  _YoutubeFullScreenState createState() => _YoutubeFullScreenState();
}

class _YoutubeFullScreenState extends State<YoutubeFullScreen> {
  CollectionReference video =
      FirebaseFirestore.instance.collection('youtube_videos');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FutureBuilder(
          future: video.doc(widget.item).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data.exists) {
              return Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data.data() as Map<String, dynamic>;
              return YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId:
                      (data != null) ? (widget.item.toString()) : "",
                  flags: YoutubePlayerFlags(
                    enableCaption: true,
                    // controlsVisibleAtStart: true,
                    // hideControls: true,
                  ),
                ),
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blue,
                progressColors: ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                  bufferedColor: Colors.yellow,
                ),
              );
            }

            return Text("loading");
          },
        ),
      ),
    );
  }
}
