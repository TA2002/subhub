import 'dart:convert';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:youtube_captions/main.dart';
import 'package:flutter/material.dart';
import 'package:youtube_captions/models/video_caption.dart';
import 'package:youtube_captions/screens/captions_page.dart';
import 'package:youtube_captions/services/alert_dialog.dart';
import 'package:youtube_captions/style.dart';
import 'package:youtube_captions/widgets/text_field.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../strings.dart';
import '../widgets/video_feed_tile.dart';
import 'feed.dart';
import 'package:http/http.dart' as http;
class CategoryPage extends StatefulWidget {
  final int categoryNumber;
  final bool darkMode;

  CategoryPage(this.categoryNumber, this.darkMode);
//  TabNavigator({Key key, this.titulo, this.numTab=0, this.logeado=false }): super(key: key);
//
//  //final LoginDto login;
//  final String titulo;
//  final int numTab;
//  bool logeado;

  @override
  CategoryPageState createState() => CategoryPageState(categoryNumber, darkMode);
}

class CategoryPageState extends State<CategoryPage> {
  int categoryNumber;
  bool darkMode;
  bool _reading = false;

  var listOfVideos;
  bool didRequest = false;
  String currentPageToken;
  List<Video> searchResults = [];

  fetchVideoListByCategory(String categoryID) async {
    var initialUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&type=video&videoCaption=closedCaption&videoCategoryId=$categoryID&key=${API_KEY2}';
    if(currentPageToken != null && currentPageToken != '' && currentPageToken.length >= 2){
      initialUrl += ('&pageToken=' + currentPageToken);
    }
    //print('initial url ' + initialUrl);
    final data = await http.get(initialUrl);
    var map = json.decode(data.body);
    if(searchResults.length < map['pageInfo']['totalResults']){
      var items = map['items'];
      for(var i in items){
        var videoTitle = i['snippet']['title'];
        videoTitle = videoTitle.replaceAll('&#39;', '\'');
        videoTitle = videoTitle.replaceAll('&quot;', '"');
        var channelTitle = i['snippet']['channelTitle'];
        channelTitle = channelTitle.replaceAll('&#39;', '\'');
        channelTitle = channelTitle.replaceAll('&quot;', '"');
        var temporaryVideo = Video.fromJson(videoTitle, channelTitle, i['id']['videoId'], i['snippet']['thumbnails']['high']['url'], i['snippet']['publishedAt']);
        searchResults.add(temporaryVideo);
      }
      currentPageToken = map['nextPageToken'];
      didRequest = false;
      setState(() {

      });
    }
    else{
      didRequest = true;
    }
  }


  getSubtitleLanguages(String IDForSearch) async {
    setState(() {
      _reading = true;
    });
    if(IDForSearch.length <= 5 || IDForSearch.length == null){
      setState(() {
        _reading = false;
      });
      errorDialog(1, context);
    }

    else if(IDForSearch != null){
      //print(IDForSearch + ' searching');
      //print(YoutubePlayer.convertUrlToId(_textController.text));
      // ignore: non_constant_identifier_names
      final String URLForSubtitleLanguages = 'https://www.googleapis.com/youtube/v3/captions?videoId=' + IDForSearch + '&part=snippet&key=${API_KEY2}';
      //print(URLForSubtitleLanguages);
      var data = await http.get(URLForSubtitleLanguages);
      Map<String, dynamic> map = json.decode(data.body);
      List jsonData = map["items"];
      Set<String> languages = {};
      for(var u in jsonData){
        //print('salute $u');
        String language = u["snippet"]["language"];
        if(u["snippet"]["trackKind"] != 'asr'){
          languages.add(language);
        }
      }
      //print('languages ' + languages.toString());
      if(languages.isEmpty){
        setState(() {
          _reading = false;
        });
        errorDialog(2, context);
      }
      else{
        UserUrl = IDForSearch;
        setState(() {
          _reading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CaptionsPage(languages, darkMode),
            ));
      }
    }

    else{
      setState(() {
        _reading = false;
      });
      errorDialog(1, context);
    }
    // ignore: non_constant_identifier_names

  }

  CategoryPageState(this.categoryNumber, this.darkMode);

  void didUpdateWidget(CategoryPage oldWidget){
    if(oldWidget.categoryNumber != widget.categoryNumber || oldWidget.darkMode != widget.darkMode){
      categoryNumber = widget.categoryNumber;
      darkMode = widget.darkMode;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState(){
    super.initState();
    fetchVideoListByCategory(Strings.categoriesID[categoryNumber]);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.myOrangeColor
        ),
        centerTitle: true,
        title: Text(Strings.categories[categoryNumber], style: AppTheme.tabBar,),
        backgroundColor: darkMode? Colors.black : Colors.white,

      ),
      body: LoadingOverlay(
        isLoading: _reading,
        child: Container(
          color: darkMode? Colors.black87 : Colors.white70,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: searchResults.length,
            itemBuilder: (context, index){
              if(index >= searchResults.length - 1 && searchResults.length > 0 && didRequest == false){
                //print('hey army');
                didRequest = true;
                fetchVideoListByCategory(Strings.categoriesID[categoryNumber]);
//                            WidgetsBinding.instance.addPostFrameCallback((_){
//                              setState(() {
//                                didRequest = true;
//                              });
//                            });

                //fetchVideoList('kz', context);
              }
              if(searchResults.length == 0){
                return Container(
                  color: darkMode? Colors.white.withOpacity(0.9) : Colors.black54,
                  child: Center(
                    child: Text('Loading'),
                  ),
                );
              }
                return GestureDetector(
                  onTap: (){
                    getSubtitleLanguages(searchResults[index].videoID);
                  },
                  child: VideoFeedTile(videoID: searchResults[index].videoID, title: searchResults[index].title, thumbnailUrl: searchResults[index].thumbnailURL, channelTitle: searchResults[index].channelTitle, publishedAt: searchResults[index].publishedAt, darkMode: darkMode,),
                );
            },
          ),
        ),
      ),
    );
  }

}