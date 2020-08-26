import '../services/shared_pref.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../strings.dart';
import 'package:flutter/material.dart';
import 'package:youtube_captions/widgets/caption_container.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/video_caption.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:text_style_editor/text_style_editor.dart';
import '../style.dart';

class CaptionsPage extends StatefulWidget {
  Set<String> listOfLanguages;
  bool darkMode;
  //final String userVideoURL;
  CaptionsPage(this.listOfLanguages, this.darkMode);

  @override
  CaptionsPageState createState() => CaptionsPageState(listOfLanguages, darkMode);
}

var UserUrl = "";

class CaptionsPageState extends State<CaptionsPage> {
  //final String userVideoURL;
  TextStyle textStyle;
  TextAlign textAlign;
  bool darkMode;

  ScrollController listViewController = ScrollController();
  Set<String> listOfLanguages;
  var futureCaptionsList;
  var filteredFutureCaptionsList;
  CaptionsPageState(this.listOfLanguages, this.darkMode);
  //YoutubePlayerController _controller;
  String searchedWord;
  Future<String> nameOfTheVideo;
  List<bool> highlightedTiles = [];
  List<Captions> captionsForStream = [];
  YoutubePlayerController youtubeVideoController = new YoutubePlayerController(initialVideoId: YoutubePlayer.convertUrlToId(UserUrl));
  TextEditingController _controllerOfSearcher = new TextEditingController();
  var cnt = 0;
  var last = 1.0;

  bool liked = false;


  String selectedUser;
  List<String> users;
  List<String> likedVideos;



  showEditorDialog(){
    var tempTextStyle = TextStyle(fontSize: 15, fontFamily: 'NotoSans-Regular');
    var tempTextAlign = TextAlign.left;
    return showDialog(
        context: context,
        builder: (context) {
                return AlertDialog(
                    actions: <Widget>[
                      Container(
                        width: double.maxFinite,
                        child: Align(
                          alignment: Alignment.center,
                          child: new FlatButton(
                            child: new Text('SAVE CHANGES', style: AppTheme.dropdownMenu,),
                            onPressed: () {
                              setState(() {
                                textStyle = tempTextStyle;
                                textAlign = tempTextAlign;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      )
                    ],
                    scrollable: true,
                    title: Text('Adjust the font', textAlign: TextAlign.center,
                      style: AppTheme.dropdownMenu,),
                    content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {return Container(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            width: double.maxFinite,
                            child: Text(
                              Strings.sampleText,
                              style: tempTextStyle,
                              textAlign: tempTextAlign,
                            ),
                          ),
                          Container(
                            child: TextStyleEditor(
                              height: 200,
                              textStyle: tempTextStyle,
                              onTextStyleChanged: (value) {
                                //print('$value text style');
                                setState(() {
                                  tempTextStyle = value;
                                  //textStyle = value;

                                });
                              },
                              onTextAlignChanged: (value) {
                                //print('$value text align');
                                setState(() {
                                  tempTextAlign = value;
                                  //textAlign = value;
                                });
                              },
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButton(onPressed: (){
                              setState(() {
                                tempTextStyle = TextStyle(fontSize: 15, fontFamily: 'NotoSans-Regular');
                                tempTextAlign = TextAlign.left;
                              });
                            }, child: new Text('SET DEFAULT', style: AppTheme.dropdownMenu,)),
                          ),
                        ],
                      ),
                    );})
                );

        }
    );
  }

  void update(Future<List<Captions>> listForFunction) {
    setState(() {
      filteredFutureCaptionsList = listForFunction;
    });
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('CHOOSE LANGUAGE', textAlign: TextAlign.center, style: AppTheme.dropdownMenu,),
            content: DropdownButton<String>(
              iconDisabledColor: AppTheme.myOrangeColor,
              iconEnabledColor: AppTheme.myOrangeColor,
              hint:  Text("${listOfLanguages.first}", style: AppTheme.dropdownMenu),
              dropdownColor: Colors.white,
              value: selectedUser,
              // ignore: non_constant_identifier_names
              onChanged: (String Value) {
                setState(() {
                  selectedUser = Value;
                  futureCaptionsList = getSubtitles(Value);
                  filteredFutureCaptionsList = futureCaptionsList;
                });
              },
              items: listOfLanguages.map((String user) {
                return  DropdownMenuItem<String>(
                  value: user,
                  child: Text(
                    user,
                    style: AppTheme.dropdownMenu
                  ),
                );
              }).toList(),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK', style: AppTheme.dropdownMenu,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  launchUrl() async {
    var url = 'https://www.youtube.com/watch?v=' + UserUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getSubtitles(String language) async {
    var strings = ['first'];
    var videoID = UserUrl;
    var myUrl = 'https://video.google.com/timedtext?lang=' + language + '&v=' + videoID;
    //print('myVideoURL' + myUrl);
    var data = await http.get(myUrl);
    List<Captions> captions = [];
    final document = xml.parse(data.body);
    var elements = document.findAllElements("transcript");
    for(var element in elements){
      for(var values in element.findAllElements('text')) {
        String edited = values.text.replaceAll('&#39;', '\'');
        edited = edited.replaceAll('&quot;', '"');
        var caption = Captions.fromXML(edited, double.parse(values.getAttribute('start')), double.parse(values.getAttribute('dur')));
        captions.add(caption);
        highlightedTiles.add(false);
      }
    }
    if (captionsForStream.isEmpty){
      captionsForStream = captions;
    }
    return captions.toList();
  }

  saveTheUrl() async {
    List<String> myStringList = await readUrl();
    if(!myStringList.contains(UserUrl)){
      myStringList.add(UserUrl);
    }
    await writeUrl(myStringList);
  }

//  addListener() {
//    youtubeVideoController.addListener(() {
//      if(youtubeVideoController.value.position.inSeconds != null && captionsForStream != null && highlightedTiles != null){
//        var currentTime = youtubeVideoController.value.position.inSeconds;
//        if(currentTime >= captionsForStream[cnt].startTime.toInt() && currentTime <= (captionsForStream[cnt].startTime + captionsForStream[cnt].duration).toInt()){
//          if(!highlightedTiles[cnt]){
//            setState(() {
//              highlightedTiles[cnt] = true;
//            });
//          }
//        }
//        else if(currentTime >= captionsForStream[cnt].startTime.toInt() && currentTime > (captionsForStream[cnt].startTime + captionsForStream[cnt].duration).toInt()){
//          highlightedTiles[cnt] = false;
//          cnt++;
//        }
//        else if(currentTime <= captionsForStream[cnt].startTime && currentTime >= 0 && captionsForStream[cnt].startTime >= 0){
//          setState(() {
//            highlightedTiles[cnt] = false;
//            var index = captionsForStream.indexWhere((element) => element.startTime <= currentTime && element.startTime + element.duration >= currentTime);
//            if(index != -1){
//              cnt = index;
//              highlightedTiles[cnt] = true;
//            }
//          });
//        }
//      }
//    });
//  }

  gettingCaptionList() async {
    var temporaryCaptions = await getSubtitles(listOfLanguages.first);
    bool add = false;
    if (captionsForStream.isEmpty){
      add = true;
    }
    for(int i = 0; i < temporaryCaptions.length; i++){
      highlightedTiles.add(false);
      if(add){
        captionsForStream.add(temporaryCaptions);
      }
    }
    return temporaryCaptions;
  }

  readVideoList() async {
    likedVideos = await readLikedVideos();
  }

  initState() {
    textStyle =
        TextStyle(fontSize: 15, fontFamily: 'NotoSans-Regular');
    saveTheUrl();
    //addListener();
    searchedWord = '';
    futureCaptionsList = getSubtitles(listOfLanguages.first);
    filteredFutureCaptionsList = futureCaptionsList;
    youtubeVideoController = YoutubePlayerController(
        initialVideoId: UserUrl,
        flags: YoutubePlayerFlags(
            autoPlay: true,
            hideThumbnail: true,
            enableCaption: false,
            controlsVisibleAtStart: false
        )
    );
    youtubeVideoController.play();
    //saveUrl(UserUrl);
    readVideoList();
    super.initState();
  }
  //bool get wantKeepAlive => true;
  //final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override

  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            //centerTitle: true,
            backgroundColor: darkMode? Colors.black : Colors.white,
            iconTheme: IconThemeData(
                color: Colors.deepOrange
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.language), onPressed: () {_displayDialog(context);},),
              IconButton(icon: Icon(Icons.text_fields),
                onPressed: (
                  ) {showEditorDialog(); },),
              Builder(
                builder: (BuildContext context){
                  return IconButton(
                    icon: liked? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                    onPressed: () {
                      setState(() {
                        liked = !liked;
                      });
                      if(liked){
                        if(likedVideos == null || likedVideos.length == 0){
                          likedVideos = [];
                          likedVideos.add(UserUrl);
                          writeLikedVideos(likedVideos);
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('The video is added to favorite'))
                          );
                        }
                        else if(!likedVideos.contains(UserUrl)){
                          likedVideos.add(UserUrl);
                          writeLikedVideos(likedVideos);
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('The video is added to favorite'))
                          );
                        }
                      }
                      else{
                        likedVideos.remove(UserUrl);
                        writeLikedVideos(likedVideos);
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('The video is removed from favorite'))
                        );
                      }
                      setState(() {

                      });
                    },);
                }
              ),
              IconButton(icon: Icon(Icons.open_in_new), onPressed: () {launchUrl(); },),
//              PopupMenuButton<String>(
//                onSelected: (String result) {
//                  print(result + ' result');
//                  launchUrl(result);
//                  setState(() {
//                }); },
//                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                  const PopupMenuItem<String>(
//                    value: 'Download Subtitles',
//                    child: Text('Download Subtitles'),
//                  ),
//                  const PopupMenuItem<String>(
//                    value: 'Open in Youtube',
//                    child: Text('Open in Youtube'),
//                  ),
//                ],
//              )

            ],
//            title: Text("CAPTIONS", style: GoogleFonts.ubuntu(
//              fontWeight: FontWeight.bold
//            ),
//            ),
          ),
      ),
      body: Container(
        color: darkMode? Colors.black : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height * 0.25//orientation == Orientation.portrait ? 150 : 100
              ),
              child: YoutubePlayer(
                controller: youtubeVideoController,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Colors.black,
                      width: 2
                  ),
                )
              ),
            ),
            Container(
              color: darkMode? Colors.black : Colors.white,
              child: new Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  style: TextStyle(
                    color: darkMode? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search, color: Colors.deepOrange,),
                      //fillColor: Colors.white,
                      //filled: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      hintText: 'Search timecode by a word',

                    hintStyle: TextStyle(
                      color: darkMode? Colors.white70 : Colors.black54,
                      fontFamily: 'NotoSans-Regular'
                    ),

                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchedWord = value;
                      //filteredFutureCaptionsList = futureCaptionsList;
                    });
                  }
                ),
              ),
            ),
            Divider(color: darkMode? Colors.white : Colors.black,),

            Expanded(
              child: Container(
                color: darkMode? Colors.black : Colors.white,
                child: FutureBuilder(

                  future: filteredFutureCaptionsList,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //print(snapshot);
                    //print('height ${MediaQuery.of(context).size.height}');
                    if (snapshot.data == null) {
                      return Container (
                        decoration: BoxDecoration(
                          color: Colors.black12
                        ),
                        child: Center(
                          child: Text('Loading'),
                        ),
                      );
                    }
                    else {
                      return new ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return new CaptionListTile(snapshot.data[index].sentence, snapshot.data[index].startTime, youtubeVideoController, snapshot.data[index].duration, highlightedTiles[index], searchedWord, textStyle, textAlign, darkMode);

                          },


                      );
                    }
                  },
                ),
              ),
            ),
            //TimeCodeListView(listOfCaptions)
            //new Expanded(child: new TimeCodeListView(filteredListOfCaptions.toList(), _controller),)
          ],
        ),
      )
    );
  }

}