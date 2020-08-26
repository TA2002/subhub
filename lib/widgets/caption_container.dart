import 'dart:async';

import 'package:flutter/material.dart';
import '../screens/captions_page.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class CaptionListTile extends StatefulWidget {
  String sentence;
  double startTime;
  TextStyle textStyle;
  TextAlign textAlign;
  YoutubePlayerController _controller;
  double duration;
  bool highlight;
  String word;
  bool darkMode;
  CaptionListTile(this.sentence, this.startTime, this._controller, this.duration, this.highlight, this.word, this.textStyle, this.textAlign, this.darkMode);
  //final String userVideoURL;
  //CaptionListTile({
  //  this.sentence,
  //  this.startTime
  //});

  @override
  CaptionListTileState createState() => CaptionListTileState(sentence, startTime, _controller, duration, highlight, word, textStyle, textAlign, darkMode);
}

/*class CaptionListTileState extends State<CaptionListTile> {
  String sentence;
  double startTime;

  CaptionListTileState({
    this.sentence,
    this.startTime
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
      ),
      constraints: new BoxConstraints(
        minHeight: 70,
        maxHeight: 100
      ),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      width: double.maxFinite,
      child: Card(
        child: Row(
          children: [
            Expanded(child: Text(sentence, maxLines: 2), flex: 8,),
            Expanded(child: Text(startTime.toString()), flex: 1)
          ],
        ),
      )

    );
  }
}*/

// ignore: must_be_immutable

class CaptionListTileState extends State<CaptionListTile> {
  String sentence;
  double startTime;
  YoutubePlayerController _controller;
  double duration;
  bool highlight;
  String word;
  Color color;
  TextStyle textStyle;
  TextAlign textAlign;
  bool darkMode;


  CaptionListTileState(this.sentence, this.startTime, this._controller, this.duration, this.highlight, this.word, this.textStyle, this.textAlign, this.darkMode);
//final String userVideoURL;
//CaptionListTile({
//  this.sentence,
//  this.startTime,
 // this.controller
//});

  String convertTime(int timeToConvert) {
    int minutes = timeToConvert ~/ 60;
    int seconds;
    if  (timeToConvert>60)  {
      seconds=timeToConvert-minutes*60;
      seconds==60?seconds=0:seconds=seconds;
    }
    else  {
      seconds=timeToConvert;
    }
    return minutes.toString() + ":" + (seconds<10?"0"+seconds.toString():seconds.toString());
  }

  @override
  // ignore: must_call_super
  void initState(){
    super.initState();

    if(highlight == true){
      setState(() {
        color = Colors.white30;
      });
    }else{
      setState(() {
        color = Colors.white;
      });
    }
    //var timer = new Timer.periodic(new Duration(milliseconds:200));
  }


  void didUpdateWidget(CaptionListTile oldWidget) {
    if (oldWidget.word != widget.word || oldWidget.sentence != widget.sentence || oldWidget.startTime != widget.startTime || oldWidget.duration != widget.duration || oldWidget.highlight != widget.highlight || oldWidget.textAlign != widget.textAlign || oldWidget.textStyle != widget.textStyle || oldWidget.darkMode != widget.darkMode) {
      // values changed, restart animation.
      sentence = widget.sentence;
      startTime = widget.startTime;
      _controller = widget._controller;
      duration = widget.duration;
      highlight = widget.highlight;
      word = widget.word;
      textStyle = widget.textStyle;
      textAlign = widget.textAlign;
      darkMode = widget.darkMode;
      if(highlight == true){
        setState(() {
          color = Colors.white30;
        });
      }else{
        setState(() {
          color = Colors.white;
        });
      }

      //endTime = widget.endTime;
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget build(BuildContext context) {
    if(sentence.toLowerCase().contains(word.toLowerCase())){
      return Container(
        color: darkMode? Colors.black.withOpacity(0.9) : Colors.white,
        child: ListTile(
          leading: GestureDetector(child: Text(convertTime(startTime.toInt()), maxLines: 1, style: textStyle.copyWith(color: Colors.deepOrange),),
            onTap: (){
              _controller.seekTo(Duration(seconds: startTime.toInt()));
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.share),
            color: Colors.deepOrange,
            onPressed: (){
              Share.share('https://www.youtube.com/watch?v=${UserUrl}&t=${startTime.toInt()}s');
            },
          ),
          title: Text(sentence, style: textStyle.copyWith(
            color: darkMode? Colors.white : Colors.black,
          ), textAlign: textAlign,),
        ),
      );
    }
    else{
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }
  }
}
