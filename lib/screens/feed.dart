import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_captions/models/video_caption.dart';
import 'package:youtube_captions/screens/by_category.dart';
import 'package:youtube_captions/services/shared_pref.dart';
import 'package:youtube_captions/size_config.dart';
import 'package:youtube_captions/style.dart';
import 'package:youtube_captions/widgets/text_field.dart';
import 'package:youtube_captions/widgets/video_feed_tile.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../main.dart';
import '../strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'by_category.dart';
import '../services/alert_dialog.dart';
import 'captions_page.dart';
import 'package:loading_overlay/loading_overlay.dart';

class FeedScreen extends StatefulWidget {
  final bool darkMode;

  FeedScreen({Key key, this.darkMode}) : super(key: key);

  FeedScreenState createState() => FeedScreenState(darkMode);
}

class FeedScreenState extends State<FeedScreen> {
  var imagePath = 'assets/images/final_transparent_logo.png';
  final colorOrange = const Color(0xFFED3731);
  final borderColor = const Color(0xFFD4C5C5);
  bool darkMode;
  var listOfVideos;
  bool _reading = false;
  var listOfLikedVideos;
  bool didRequest;
  String currentPageToken;
  List<Video> searchResults = [];

  FeedScreenState(this.darkMode);

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
      //print(YoutubePlayer.convertUrlToId(_textController.text));
      // ignore: non_constant_identifier_names
      final String URLForSubtitleLanguages = 'https://www.googleapis.com/youtube/v3/captions?videoId=' + IDForSearch + '&part=snippet&key=${API_KEY2}';
      var data = await http.get(URLForSubtitleLanguages);
      Map<String, dynamic> map = json.decode(data.body);
      List jsonData = map["items"];
      Set<String> languages = {};
      for(var u in jsonData){
        String language = u["snippet"]["language"];
        if(u["snippet"]["trackKind"] != 'asr'){
          languages.add(language);
        }
      }
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
            )).then((_) {
          // you have come back to your Settings screen
          setState(() {

          });
        });
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

  fetchVideoList2() async {
    var initialUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&type=video&videoCaption=closedCaption&key=${API_KEY2}';
    if(currentPageToken != null && currentPageToken != '' && currentPageToken.length >= 2){
      initialUrl += ('&pageToken=' + currentPageToken);
    }
//    print(initialUrl);
    final data = await http.get(initialUrl);
    var map = json.decode(data.body);
    var items = map['items'];
    for(var i in items){
      var videoTitle = i['snippet']['title'];
      videoTitle = videoTitle.replaceAll('&#39;', '\'');
      videoTitle = videoTitle.replaceAll('&quot;', '"');
      var channelTitle = i['snippet']['channelTitle'];
      channelTitle = channelTitle.replaceAll('&#39;', '\'');
      channelTitle = channelTitle.replaceAll('&quot;', '"');
      //print(videoTitle);
      var temporaryVideo = Video.fromJson(videoTitle, channelTitle, i['id']['videoId'], i['snippet']['thumbnails']['high']['url'], i['snippet']['publishedAt']);
      //print(temporaryVideo);
      searchResults.add(temporaryVideo);
    }
    //print(map);
    //print('i am out ' + map['nextPageToken']);
    currentPageToken = map['nextPageToken'];
    didRequest = false;
    setState(() {

    });
  }
  //var imageHeight;


  fetchAndParse(String url, cnt) async {
    if(url.length >= 20){
      url = YoutubePlayer.convertUrlToId(url);
    }
    var modifiedUrl = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=' + url + '&key=' + API_KEY2;
    final data = await http.get(modifiedUrl);
    var map = json.decode(data.body);
    for(var i in map['items']){
      var videoTitle = i['snippet']['title'];
      videoTitle = videoTitle.replaceAll('&#39;', '\'');
      videoTitle = videoTitle.replaceAll('&quot;', '"');
      var channelTitle = i['snippet']['channelTitle'];
      channelTitle = channelTitle.replaceAll('&#39;', '\'');
      channelTitle = channelTitle.replaceAll('&quot;', '"');
      var temporaryVideo = Video.fromJson(videoTitle, channelTitle, i['id'], i['snippet']['thumbnails']['high']['url'], i['snippet']['publishedAt']);
      listOfVideos.add(temporaryVideo);
    }
  }

  fetchAndParseLikedVideos(String url, cnt) async {
    if(url.length >= 20){
      url = YoutubePlayer.convertUrlToId(url);
    }
    var modifiedUrl = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=' + url + '&key=' + API_KEY2;
    final data = await http.get(modifiedUrl);
    var map = json.decode(data.body);
    for(var i in map['items']){
      var videoTitle = i['snippet']['title'];
      videoTitle = videoTitle.replaceAll('&#39;', '\'');
      videoTitle = videoTitle.replaceAll('&quot;', '"');
      var channelTitle = i['snippet']['channelTitle'];
      channelTitle = channelTitle.replaceAll('&#39;', '\'');
      channelTitle = channelTitle.replaceAll('&quot;', '"');
      var temporaryVideo = Video.fromJson(videoTitle, channelTitle, i['id'], i['snippet']['thumbnails']['high']['url'], i['snippet']['publishedAt']);
      listOfLikedVideos.add(temporaryVideo);
    }
  }

  void startDownloading(var listOfUrls) async {
    var cnt = -1;
    for(var url in listOfUrls){
      cnt++;
      await fetchAndParse(url, cnt);
    }
    //print(listOfVideos);
    return listOfVideos;
  }

  void startDownloadingLikedVideos(var listOfUrls) async {
    var cnt = -1;
    for(var url in listOfUrls){
      cnt++;
      await fetchAndParseLikedVideos(url, cnt);
    }
    //print(listOfLikedVideos);
    return listOfLikedVideos;
  }

  readUrls() async {
    listOfVideos = [];
    var myStringList = await readUrl();
    return startDownloading(myStringList);
  }

  readUrlsOfLikedVideos() async {
    listOfLikedVideos = [];
    var myStringList = await readLikedVideos();
    return startDownloadingLikedVideos(myStringList);
  }

  @override
  void initState() {
    super.initState();
    didRequest = false;
    //print('my Height');
    //topPadding = SizeConfig.heightMultiplier;
    //print(StringExtension.displayTimeAgoFromTimestamp('2020-08-15T01:10:00Z'));
    //print(SizeConfig.heightMultiplier);
    fetchVideoList2();
  }

  void didUpdateWidget(FeedScreen oldWidget) {
    if(oldWidget.darkMode != widget.darkMode){
      setState(() {
        darkMode = widget.darkMode;
      });
      super.didUpdateWidget(oldWidget);
    }
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 1, left: 8),
            child: Image.asset(imagePath, fit: BoxFit.fitHeight, height: 50,),
          ),
          //title: Text('Search'),
          backgroundColor: darkMode? Colors.black : Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabBar(
              indicatorColor: Colors.deepOrange,
              tabs: [
                Tab(
                    child: Text(
                      "TRENDING",
                      style: AppTheme.feedTabbar,
                    ),
                ),
                Tab(
                  child: Text(
                    "FAVORITE",
                    style: AppTheme.feedTabbar
                  ),
                ),
                Tab(
                  child: Text(
                    "HISTORY",
                    style: AppTheme.feedTabbar,
                  ),
                ),
              ],

            ),
          ),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              icon: Icon(Icons.search, color: Colors.deepOrange,),
              onPressed: (){
                showSearch(context: context, delegate: DataSearch(darkMode));
              },
            )
          ],
        ),
        body: LoadingOverlay(
          isLoading: _reading,
          child: TabBarView(
            children: <Widget>[
              Container(
                  color: darkMode? Colors.black.withOpacity(0.9) : Colors.white10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Flexible(
                      flex: 1,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: searchResults.length + 1,
                        itemBuilder: (context, index){
                          if(index >= searchResults.length && searchResults.length > 0 && didRequest == false){
                            //print('hey army');
                            didRequest = true;
                            fetchVideoList2();
//                            WidgetsBinding.instance.addPostFrameCallback((_){
//                              setState(() {
//                                didRequest = true;
//                              });
//                            });

                            //fetchVideoList('kz', context);
                          }
                          if(searchResults.length == 0){
                            return Container(
                              color: darkMode? Colors.black.withOpacity(0.9) : Colors.white10,
                              child: Center(
                                child: Text('Loading', style: TextStyle(
                                  color: darkMode? Colors.white10 : Colors.black.withOpacity(0.9),
                                )),
                              ),
                            );
                          }
                          if(index == 0){
                            return Container(
                              color: darkMode? Colors.black.withOpacity(0.9) : Colors.white10,
                              width: SizeConfig.screenWidth,
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: Strings.categories.length,
                                itemBuilder: (context, index){
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: (){
                                        //Navigator.pushNamed(context, CategoryScreen, arguments: index.toInt());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CategoryPage(index, darkMode),
                                            ));
                                      },
                                      child: Ink(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.deepOrange,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                              child: Center(
                                                child: Text(Strings.categories[index], style: AppTheme.horizontalListView,),
                                              ),
                                            )
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          else{
                            return GestureDetector(
                                onTap: (){
                                  //print('this is my video name ' + searchResults[index-1].title + '  ' + '$index');
                                  getSubtitleLanguages(searchResults[index-1].videoID);
                                },
                                //key: UniqueKey(),
                              child: VideoFeedTile(videoID: searchResults[index-1].videoID, title: searchResults[index-1].title, thumbnailUrl: searchResults[index-1].thumbnailURL, channelTitle: searchResults[index-1].channelTitle, publishedAt: searchResults[index-1].publishedAt, darkMode: darkMode,)
                            );
                          }

                        },
                      )

                    ),
                  ],
                )
              ),
              Flexible(
                flex: 1,
                child: Container(
                  color: darkMode? Colors.black.withOpacity(0.9) : Colors.white,
                  child: FutureBuilder(
                    future: readUrlsOfLikedVideos(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //print(snapshot);
                      //var recentContainingWord = recentSearch.where((element) => element.startsWith(query)).toList();
                      if (snapshot.data == null) {
                        return Container (
                          color: darkMode? Colors.black.withOpacity(0.9) : Colors.white,
                          child: Center(
                            child: Text('Loading', style: TextStyle(
                              color: darkMode? Colors.white10 : Colors.black.withOpacity(0.9),
                            )),
                          ),
                        );
                      }
                      else {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index){
                            return GestureDetector(
                                onTap: (){
                                  //print('this is my video name ' + searchResults[index-1].title + '  ' + '$index');
                                  getSubtitleLanguages(snapshot.data[index].videoID);
                                },
                                child: VideoFeedTile(videoID: snapshot.data[index].videoID, title: snapshot.data[index].title, thumbnailUrl: snapshot.data[index].thumbnailURL, channelTitle: snapshot.data[index].channelTitle, publishedAt: snapshot.data[index].publishedAt, darkMode: darkMode,));
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  color: darkMode? Colors.black.withOpacity(0.9) : Colors.white,
                  child: FutureBuilder(
                    future: readUrls(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //print('tryna build');
                      //print(snapshot);
                      //var recentContainingWord = recentSearch.where((element) => element.startsWith(query)).toList();
                      if (snapshot.data == null) {
                        return Container (
                          color: darkMode? Colors.black.withOpacity(0.9) : Colors.white,
                          child: Center(
                            child: Text('Loading', style: TextStyle(
                              color: darkMode? Colors.white10 : Colors.black.withOpacity(0.9),
                            )),
                          ),
                        );
                      }
                      else {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index){
                            return GestureDetector(
                                onTap: (){
                                  //print('this is my video name ' + searchResults[index-1].title + '  ' + '$index');
                                  getSubtitleLanguages(snapshot.data[index].videoID);
                                },
                                child: VideoFeedTile(videoID: snapshot.data[index].videoID, title: snapshot.data[index].title, thumbnailUrl: snapshot.data[index].thumbnailURL, channelTitle: snapshot.data[index].channelTitle, publishedAt: snapshot.data[index].publishedAt, darkMode: darkMode,));
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              //Container(color: Colors.purple),
              //Container(color: Colors.red),
              //Container(color: Colors.purple),
            ],
          ),
        ),
      ),
    );
  }

}

class DataSearch extends SearchDelegate<String> {
  final colorOrange = const Color(0xFFED3731);
  bool darkMode;
  bool _reading = false;
  List<String> recentSearch = [];
  bool didRequest = false;
  List<String> mySuggestions;
  String currentPageToken;
  List<Video> searchResults = [];

  DataSearch(this.darkMode);

  fetchVideoList(var region, BuildContext context) async {
    var initialUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&type=video&q=$query&videoCaption=closedCaption&key=${API_KEY2}';
    if(currentPageToken != null && currentPageToken != '' && currentPageToken.length >= 2){
      initialUrl += ('&pageToken=' + currentPageToken);
    }
    final data = await http.get(initialUrl);
    var map = json.decode(data.body);
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
    //print(map);
    //print('i am out ' + map['nextPageToken']);
    currentPageToken = map['nextPageToken'];
    didRequest = false;
    return searchResults;
  }
  getSubtitleLanguages(String IDForSearch, BuildContext context) async {
    if(IDForSearch.length <= 5 || IDForSearch.length == null){
      _reading = false;
      errorDialog(1, context);
    }

    else if(IDForSearch != null){
      //print(YoutubePlayer.convertUrlToId(_textController.text));
      // ignore: non_constant_identifier_names
      final String URLForSubtitleLanguages = 'https://www.googleapis.com/youtube/v3/captions?videoId=' + IDForSearch + '&part=snippet&key=${API_KEY2}';
      var data = await http.get(URLForSubtitleLanguages);
      Map<String, dynamic> map = json.decode(data.body);
      List jsonData = map["items"];
      Set<String> languages = {};
      for(var u in jsonData){
        String language = u["snippet"]["language"];
        if(u["snippet"]["trackKind"] != 'asr'){
          languages.add(language);
        }
      }
      if(languages.isEmpty){
        _reading = false;
        errorDialog(2, context);
      }
      else{
        UserUrl = IDForSearch;
        _reading = false;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CaptionsPage(languages, darkMode),
            ));
      }
    }

    else{
      _reading = false;
      errorDialog(1, context);
    }
    // ignore: non_constant_identifier_names

  }

  fetchSuggestions() async {
    var url = 'http://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=$query';
    //print('modified url ' + url);
    final data = await http.get(url);
    //print('your response ' + data.toString());
    var map = json.decode(data.body);
    List<String> toReturn = [];
    for(var i in map[1]){
      toReturn.add(i);
    }
    return toReturn;
  }

  readSuggestions(var stringToSave) async{
    List<String> tempRecentSearch = await readRecentSuggestionsWithoutFuture();
    if(!tempRecentSearch.contains(stringToSave))
    {
      tempRecentSearch.add(stringToSave);
      writeRecentSuggestions(tempRecentSearch);
    }

    //var tempRecentSearch = await readRecentSuggestions();
    //recentSearch = tempRecentSearch;
    //print('in function ' + tempRecentSearch);
    //return tempRecentSearch;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear, color: Colors.deepOrange,), onPressed: (){
      query = '';
    },)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      color: Colors.deepOrange,
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState){
        readSuggestions(query);
        return LoadingOverlay(
          isLoading: _reading,
          child: FutureBuilder(
            future: fetchVideoList("us", context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //var recentContainingWord = recentSearch.where((element) => element.startsWith(query)).toList();
              if (snapshot.data == null) {
                return Container (
                  color: darkMode? Colors.black.withOpacity(0.9) : Colors.white10,
                  child: Center(
                    child: Text('Loading'),
                  ),
                );
              }
              else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    if(index >= snapshot.data.length - 1 && snapshot.data.length > 0 && didRequest == false){
                      //print('hey army');
                      WidgetsBinding.instance.addPostFrameCallback((_){
                        setState(() {
                          didRequest = true;
                        });
                      });

                      //fetchVideoList('kz', context);
                    }
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          _reading = true;
                        });
                        getSubtitleLanguages(snapshot.data[index].videoID, context).then((_) {
                          // you have come back to your Settings screen
                          setState(() {

                          });
                        });
                      },
                      child: VideoFeedTile(videoID: snapshot.data[index].videoID, title: snapshot.data[index].title, thumbnailUrl: snapshot.data[index].thumbnailURL, channelTitle: snapshot.data[index].channelTitle, publishedAt: snapshot.data[index].publishedAt, darkMode: darkMode,),
                    );
                  },
                );
              }
            },
          ),
        );
      }
    );
  }



  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestionList;
    //var details = new Map();
    if(query.isEmpty){
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FutureBuilder(
                future: readRecentSuggestions(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  {
                    //print('your suggestions ' + snapshot.data);
                    recentSearch = snapshot.data;
                    if(snapshot.data == []){
                      return Expanded(
                        child: Container(
                          color: darkMode ? Colors.black.withOpacity(0.9) : Colors.white,
                        ),
                      );
                    }
                    else{
                      return Container(
                        color: darkMode ? Colors.black.withOpacity(0.9) : Colors.white,
                        child: ListView.builder(itemBuilder: (context, index) =>
                            ListTile(
                              leading: Icon(
                                  Icons.youtube_searched_for, color: Colors.deepOrange),
                              title: Text(snapshot.data[index],
                                style: AppTheme.suggestions.copyWith(
                                    color: darkMode ? Colors.white : Colors.black
                                ),
                              ),
                              onTap: () {
                                query = snapshot.data[index];
                                showResults(context);
//                                recentSearch.add(snapshot.data[index]);
//                                print('mod array');
//                                print(recentSearch);
//                                writeRecentSuggestions(recentSearch);
//                                query = snapshot.data[index];
//                                showResults(context);
                              },
                            ),
                          itemCount: snapshot.data.length,
                        ),
                      );
                    }
                  }

                }
                );


          }
      );
    }
    else{
      //fetchSuggestions();
      //suggestionList = mySuggestions;
      return Container(
        color: darkMode? Colors.black.withOpacity(0.9) : Colors.white,
        child: FutureBuilder(
          future: fetchSuggestions(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //var searchedRecent = recentSearch
            List<String> recentContainingWord = recentSearch.where((element) => element.startsWith(query)).toList();
            List<String> newList = recentContainingWord;
            if(snapshot.data!= null){
              newList = newList + snapshot.data;
            }
            if (snapshot.data == null) {
              return Container (
                child: Center(
                  child: Text('Loading'),
                ),
              );
            }
            else {
              return ListView.builder(
                  itemCount: snapshot.data.length + recentContainingWord.length,
                  itemBuilder: (context, index) {
                    if(index >= recentContainingWord.length && recentContainingWord.contains(newList[index])){
                      return Container(height: 0,);
                    }
                    else{
                      return Ink(
                        child: ListTile(
                          leading: recentContainingWord.contains(newList[index])? Icon(Icons.youtube_searched_for, color: Colors.deepOrange,) : Icon(Icons.search, color: Colors.deepOrange),
                          title: Text(newList[index],
                            style: AppTheme.suggestions.copyWith(
                                color: darkMode? Colors.white : Colors.black
                            ),
                          ),
                          onTap: (){
                            query = newList[index];
                            showResults(context);
                          },
                        ),
                      );
                    }

                  }
              );
            }
          },
        ),
      );
    }


  }



}



