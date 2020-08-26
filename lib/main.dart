import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_captions/screens/captions_page.dart';
import 'package:youtube_captions/size_config.dart';
import 'package:youtube_captions/style.dart';
import 'screens/new_home_page.dart';
import 'screens/feed.dart';
import 'widgets/tab_navigator.dart';
import 'size_config.dart';
import 'screens/by_category.dart';

const CaptionsScreen = '/captions_page';
const HomeScreen = '/feed';
const CategoryScreen = '/by_category';

void main() {
  runApp(MyApp());
}

class ScreenArguments {
  final String title;
  final String message;
  ScreenArguments(this.title, this.message);
}

class MyApp extends StatelessWidget {

//  RouteFactory _routes() {
//    return (settings) {
//      //final String argumentURL = settings.arguments;
//      final arguments = settings.arguments;
//      //final int categoryNumber = settings.arguments;
//      Widget screen;
//      switch (settings.name) {
//        case CategoryScreen:
//          screen = CategoryPage(arguments);
//          break;
//        case CaptionsScreen:
//          screen = CaptionsPage(arguments);                                     // Widget name
//          break;
//        case HomeScreen:
//          screen = FeedScreen();				   // Widget name
//          break;
//        default:
//          return null;
//      }
//      return MaterialPageRoute(builder: (BuildContext context) => screen);
//    };
//  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        return OrientationBuilder(
          builder: (context, orientation){
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              //routes: <String>,
              home: TabNavigator(),
              //onGenerateRoute: _routes(),
              theme: ThemeData(
                  unselectedWidgetColor: Colors.deepOrange,
                  primaryColor: Colors.deepOrange

              ),
            );
          },
        );
      },
    );
  }

}