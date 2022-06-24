import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final YoutubePlayerController controller;
  int rotation;
  VideoScreen({Key key, this.controller, this.rotation}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubePlayer(
          controller: widget.controller,
          bottomActions: [
            IconButton(
              onPressed: () async {
                widget.controller.pause();
                if (widget.rotation == 0) {
                  setState(() {
                    widget.rotation = 1;
                  });
                } else {
                  setState(() {
                    widget.rotation = 0;
                  });
                }
              },
              icon: Icon(
                widget.rotation == 0 ? Icons.fullscreen : Icons.fullscreen_exit,
                color: Colors.white,
              ),
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
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }
}
