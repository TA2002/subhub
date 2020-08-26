import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

saveUrl(String urlToSave) async {
  final prefs = await SharedPreferences.getInstance();

  // read
  var myStringList = prefs.getStringList('my_string_list_key') ?? [];
  //print('i am reading ' + myStringList.toString());
  if(myStringList.contains(urlToSave)){
    myStringList.remove(urlToSave);
  }
  myStringList.add(urlToSave);

// write
  prefs.setStringList('my_string_list_key', myStringList);
  //print('i am reading');
}

Future<List<String>> readUrl() async{
  final prefs = await SharedPreferences.getInstance();
  //print('printing');
  print(prefs.getStringList('my_history') ?? []);
  return prefs.getStringList('my_history') ?? [];
}

writeUrl(List<String> myStringList) async{
  final prefs = await SharedPreferences.getInstance();
  if(myStringList.length > 10){
    myStringList.removeAt(0);
  }
  //print('i am writing');
  //print(myStringList);
  prefs.setStringList('my_history', myStringList);
}

readDarkMode() async{
  final prefs = await SharedPreferences.getInstance();
  //print('printing');
  //print('reading');
  //print(prefs.getBool('dark_mode') ?? false);
  return prefs.getBool('dark_mode') ?? false;
}

writeDarkMode(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  //print('writing ' + value.toString());
  prefs.setBool('dark_mode', value);
}

Future<List<String>> readRecentSuggestions() async{
  final prefs = await SharedPreferences.getInstance();
  //print('printing');
  //print(prefs.getStringList('recent_suggestions') ?? []);
  return prefs.getStringList('recent_suggestions') ?? [];
}

writeRecentSuggestions(List<String> myStringList) async{
  final prefs = await SharedPreferences.getInstance();
  //print('writing into ');
  //print(myStringList);
  prefs.setStringList('recent_suggestions', myStringList);
}

Future<List<String>> readRecentSuggestionsWithoutFuture() async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('recent_suggestions') ?? [];
}

Future<List<String>> readLikedVideos() async{
  final prefs = await SharedPreferences.getInstance();
  //print('printing');
  //print('reading liked_videos');
  //print(prefs.getStringList('liked_videos') ?? []);
  return prefs.getStringList('liked_videos') ?? [];
}

writeLikedVideos(List<String> myStringList) async{
  final prefs = await SharedPreferences.getInstance();
  //print('writing into ');
  //print(myStringList);
  prefs.setStringList('liked_videos', myStringList);
}