import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../screens/captions_page.dart';

class VideoPlayer extends StatefulWidget {
  //final videoURL;
  YoutubePlayerController _controller;

  VideoPlayer(this._controller);
  @override
  VideoPlayerState createState() => VideoPlayerState(_controller);
}

class VideoPlayerState extends State<VideoPlayer> {
  //final videoURL;
  YoutubePlayerController _controller;

  VideoPlayerState(this._controller);

  @override
  void initState(){
    _controller = YoutubePlayerController(
      initialVideoId: UserUrl,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        hideThumbnail: true,
        enableCaption: false,
        controlsVisibleAtStart: false
      )
    );
  }

  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,

    );
  }
}