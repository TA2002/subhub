import 'package:flutter/material.dart';
import 'package:youtube_captions/models/video_caption.dart';
import '../size_config.dart';
import '../style.dart';

class VideoFeedTile extends StatelessWidget {
  final borderColor = const Color(0xFFD4C5C5);
  final String title;
  final String channelTitle;
  final String videoID;
  final String thumbnailUrl;
  final String publishedAt;
  final bool darkMode;

  VideoFeedTile({Key key, this.title, this.channelTitle, this.videoID, this.thumbnailUrl, this.publishedAt, this.darkMode}) : super(key: key);
  
  
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
//        Container(
//          height: 2,
//          color: borderColor,
//        ),
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(thumbnailUrl),
                fit: BoxFit.cover,
              ),
            ),
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenWidth / 1.77
        ),
        Container(
          //color: Colors.yellow,
          width: double.maxFinite,
          padding: EdgeInsets.all(15),
          color: darkMode? Colors.black.withOpacity(0.9) : Colors.white,
          child: Column(
            children: [
              Text(
                title,
                style: darkMode? AppTheme.videoTitleDark : AppTheme.videoTitleLight,
                maxLines: 2,
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  ('$channelTitle ⊙ ${StringExtension.displayTimeAgoFromTimestamp(publishedAt)}'),
                  style: darkMode? AppTheme.videoInfoDark : AppTheme.videoInfoLight,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        )

      ],
    );
  }
}