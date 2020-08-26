import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_captions/main.dart';
import 'package:youtube_captions/widgets/historyTile.dart';
import 'package:youtube_captions/widgets/home_title.dart';
import 'package:youtube_captions/widgets/text_field.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/historyTile.dart';
import 'captions_page.dart';
import '../services/shared_pref.dart';
import '../widgets/home_title.dart';
import '../widgets/text_field.dart';
import '../services/alert_dialog.dart';

class NewHomeApp extends StatefulWidget {
  @override
  NewHomeAppState createState() => new NewHomeAppState();
}

var globalList;

class NewHomeAppState extends State<NewHomeApp> {
  final color = Color(0xFFEEEEEE);
  var imagePath = 'assets/images/';
  bool success = false;
  final TextEditingController _textController = new TextEditingController();
  final String userTypedURL = 'https://www.youtube.com/watch?v=XBKzpTz65Io';

  //Future<List<Captions>> myCaptions;
  var myCaptions;
  var listOfImagesForListView = [];
  List<String> listOfNames = [];
  List<int> sortingNumbers = [];
  List<String> myStringList = [];

  // ignore: non_constant_identifier_names
  getSubtitleLanguages(String UrlForSearch) async {
    print(MediaQuery.of(context).size.height);
    print(UrlForSearch + ' input url');
    if(UrlForSearch.length <= 5 || UrlForSearch.length == null){
      errorDialog(1, context);
    }

    else if(YoutubePlayer.convertUrlToId(UrlForSearch) != null){
      print(UrlForSearch + ' searching');
      //print(YoutubePlayer.convertUrlToId(_textController.text));
      // ignore: non_constant_identifier_names
      final String URLForSubtitleLanguages = 'https://www.googleapis.com/youtube/v3/captions?videoId=' + YoutubePlayer.convertUrlToId(UrlForSearch) + '&part=snippet&key=AIzaSyD9lLFr0YM2mJcw48TJ0TAAYFQzxQlGUMU';
      print(URLForSubtitleLanguages);
      var data = await http.get(URLForSubtitleLanguages);
      Map<String, dynamic> map = json.decode(data.body);
      List jsonData = map["items"];
      Set<String> languages = {};
      for(var u in jsonData){
        print('salute $u');
        String language = u["snippet"]["language"];
        if(u["snippet"]["trackKind"] != 'asr'){
          languages.add(language);
        }
      }
      print('languages ' + languages.toString());
      if(languages.isEmpty){
        errorDialog(2, context);
      }
      else{
        UserUrl = UrlForSearch;
        await Navigator.pushNamed(context, CaptionsScreen, arguments: languages).then((value) {
          _textController.clear();
        });
        readUrls();
      }
    }

    else{
      errorDialog(1, context);
    }
    // ignore: non_constant_identifier_names

  }


  callback(newUrl) {
    print(newUrl + 'history name');
    final index = listOfNames.indexWhere((element) => element == newUrl);
    print('history url ' + myStringList[index]);
    getSubtitleLanguages(myStringList[index]);
  }




  void startDownloading(var listOfUrls) async {
    var cnt = -1;
    for(var url in listOfUrls){
      print('this is your item ' + url);
      cnt++;
      await fetchAndParse(url, cnt);
      print(cnt.toString() + ' my counter');
    }
    /*listOfUrls.forEach((url) async {
      print('this is your item ' + url);
      await fetchAndParse(url, cnt);
      print(cnt.toString() + ' my counter');
      cnt++;
    });*/
    print("done");
  }

  fetchAndParse(String url, cnt) async {
    print('i am in');
    var modifiedUrl = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=' + YoutubePlayer.convertUrlToId(url) + '&key=' + 'AIzaSyD9lLFr0YM2mJcw48TJ0TAAYFQzxQlGUMU';
    print('modified url ' + modifiedUrl);
    final data = await http.get(modifiedUrl);
    //print('your response ' + data.toString());
    var map = json.decode(data.body);
    print(map["items"][0]["snippet"]["title"]);
    final videoName = map["items"][0]["snippet"]["title"];
    print('videoName ' + videoName);
    listOfNames.add(videoName);
    sortingNumbers.add(cnt);
    if(listOfNames.length == myStringList.length){
      setState(() {
        listOfNames = listOfNames;
      });
    }
  }

  readUrls() async {
    listOfImagesForListView = [];
    listOfNames = [];
    sortingNumbers = [];
    // read
    //print('reading');
    myStringList = await readUrl();
    //print('list of videos');
    startDownloadingPictures(myStringList);
    startDownloading(myStringList);

  }

  void startDownloadingPictures(var listOfUrls) async {
    for(var url in listOfUrls){
      setState(() {
        //print('url ' + url);
        listOfImagesForListView.add('http://i3.ytimg.com/vi/${YoutubePlayer.convertUrlToId(url)}/0.jpg');
      });
    }
  }

  void buttonFunction(){
    getSubtitleLanguages(_textController.text);
  }

  fetchSuggestions() async {
    print('i am in suggestions');
    var url = 'http://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=Query';
    //print('modified url ' + url);
    final data = await http.get(url);
    //print('your response ' + data.toString());
    var map = json.decode(data.body);
    for(var i in map[1]){
      print(i);
      //mySuggestions.add(i);
    }
    //print(map);
  }

  @override

  void initState() {
    super.initState();
    print('hey, i am back');
    readUrls();
    fetchSuggestions();
    //_searchBarController.
    //youtubeRequest();
    //myCaptions = getData();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              //maxHeight: MediaQuery.of(context).size.height * 1.5,
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                )
            ),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeTitle(),
              BeautifulTextField(_textController),

              Padding(
                  padding: EdgeInsets.all(15),
                  child: MaterialButton(
                    height: 40,
                    disabledColor: Colors.white,
                    shape: CircleBorder(),
                    animationDuration: Duration(milliseconds: 500),
                    child: Icon(Icons.arrow_forward, size: 30, color: Colors.black,),
                    splashColor: Colors.indigo,
                    highlightColor: Colors.red,
                    elevation: 5.0,
                    onPressed: buttonFunction,
                  )
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text('HISTORY', style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: color,
                    shadows: <Shadow>[
                      Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                          color: Colors.black
                      )
                    ]
                ),),
              ),

              Container(
                height: 120,
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listOfNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return HistoryTile(listOfNames[index], listOfImagesForListView[index], callback);
                  }
                ),
              ),
              SizedBox(
                height: 30,
              )

            ],
          ),

          ),
        ),
      ),
    );
  }

}

//textStyle: myTextStyle

const myTextStyle = TextStyle(
    fontSize: 60,
    color: Color(0xFFEEEEEE),
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0, 1.0),
        blurRadius: 4.0,
        color: Color(0xFFBD10E0)
      )
    ]
);

const subtitlesTextStyle = TextStyle(
    fontFamily: 'unisansheavycaps',
    fontSize: 14,
    color: Color(0xFFEEEEEE),
    shadows: <Shadow>[
      Shadow(
          offset: Offset(0, 2.0),
          blurRadius: 4.0,
          color: Color(0xFFBD10E0)
      )
    ]
);
