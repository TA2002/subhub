import 'package:flutter/material.dart';
import 'package:youtube_captions/screens/settings_page.dart';
import 'package:youtube_captions/style.dart';
import '../screens/feed.dart';


class TabNavigator extends StatefulWidget {

//  TabNavigator({Key key, this.titulo, this.numTab=0, this.logeado=false }): super(key: key);
//
//  //final LoginDto login;
//  final String titulo;
//  final int numTab;
//  bool logeado;

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int tabIndex = 0;
  List<Widget> listScreens;
  int _currentIndex = 0;


  //GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final colorOrange = const Color(0xFFED3731);
  var darkMode = false;


  callback(bool myDarkMode){
    //print('coming');
    setState(() {
      darkMode = myDarkMode;
      listScreens = [
        FeedScreen(darkMode: darkMode,),
        SettingsScreen(callback),
      ];
    });
  }

  @override
  void initState(){
    super.initState();
    listScreens = [
      FeedScreen(darkMode: darkMode,),
      SettingsScreen(callback),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: listScreens[tabIndex],
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: AppTheme.myOrangeColor.withOpacity(0.8),
            selectedItemColor: AppTheme.myOrangeColor,
            elevation: 5,
            backgroundColor: darkMode? Colors.black : Colors.white,
            currentIndex: tabIndex,
            onTap: (int index) {
              setState(() {
                tabIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home', style: AppTheme.bottomNavigationBar,),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), title: Text('Settings', style: AppTheme.bottomNavigationBar)
              ),
//              BottomNavigationBarItem(
//                icon: Icon(Icons.settings),
//                title: Text('Tab3'),
//              ),
            ]),
        //backgroundColor: Theme.of(context).primaryColor,
    );

//      return BottomNavigationBar(
//        length: 2,
//        child: Scaffold(
//          appBar: AppBar(
//            bottom: TabBar(
//              tabs: [
//                Tab(icon: Icon(Icons.home), child: Text('Home', style: AppTheme.bottomNavigationBar,),),
//                //BottomNavigationBarItem(icon: Icon(Icons.search,), title: Text('Search', style: AppTheme.bottomNavigationBar)),
//                Tab(icon: Icon(Icons.settings), child: Text('Settings', style: AppTheme.bottomNavigationBar)),
//              ],
//            ),
//            title: Text('Tabs Demo'),
//          ),
//          body: TabBarView(
//            children: [
//              FeedScreen(darkMode: darkMode,),
//              SettingsScreen(callback),
//            ],
//          ),
//        ),
//      );
  }


  final _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home', style: AppTheme.bottomNavigationBar,),),
    //BottomNavigationBarItem(icon: Icon(Icons.search,), title: Text('Search', style: AppTheme.bottomNavigationBar)),
    BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings', style: AppTheme.bottomNavigationBar)),

  ];





//  int _selectedIndex;
//  final colorOrange = const Color(0xFFED3731);
//
//  @override
//  void initState() {
//
//    _selectedIndex = 0;
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      //key: _scaffoldKey,
//      //appBar: headContainer(),
//      //drawer: drawerContainer(),
//      body: bodyContainer(),
//      bottomNavigationBar: FlashyTabBar(
//        animationCurve: Curves.linear,
//        selectedIndex: _selectedIndex,
//        showElevation: true, // use this to remove appBar's elevation
//        onItemSelected: (index) => setState(() {
//          _selectedIndex = index;
//        }),
//        items: [
//          FlashyTabBarItem(
//            activeColor: AppTheme.myOrangeColor,
//            inactiveColor: Colors.black38,
//            icon: Icon(Icons.video_library),
//            title: Text('Main'),
//          ),
//          FlashyTabBarItem(
//            activeColor: AppTheme.myOrangeColor,
//            inactiveColor: Colors.black38,
//            icon: Icon(Icons.search),
//            title: Text('Search'),
//          ),
//          FlashyTabBarItem(
//            activeColor: AppTheme.myOrangeColor,
//            inactiveColor: Colors.black38,
//            icon: Icon(Icons.settings),
//            title: Text('Settings'),
//          ),
////          FlashyTabBarItem(
////            activeColor: colorOrange,
////            inactiveColor: Colors.black38,
////            icon: Icon(Icons.settings),
////            title: Text('Settings'),
////          ),
//        ],
//      ),
//    );
//  }
//
//  Widget bodyContainer() {
//    //cuerpo variable depende del tab que seleccione
//    //String slogan;
//    switch (_selectedIndex) {
//      case 0:
//        return FeedScreen();
//        break;
//      case 1:
//        return NewHomeApp();
//        break;
//      case 2:
//        return FeedScreen();
//        break;
//      default:
//        return FeedScreen();
//        break;
//    }
//  }

//  Widget headContainer() {
//    //appbar variable, depende del tab seleccionado
//    //String slogan;
//    switch (_selectedIndex) {
//      case 0:
//        return HomeHeaderTap(); //appbar del home, es solo visual, ya que al hacer tap va a headBusqueda
//        break;
//      case 1:
//        return HomeHeader(); //header normal, sin tap
//        break;
//      case 2: //headers de la vista de usuarios
//        if( widget.logeado ){
//          return HomeHeaderUsuario(); //si esta logeado le muestra distintas opciones con un drawer
//        } else {
//          return HomeHeaderNo(); //muestra un login si no esta logeado con un header normal
//        }
//        break;
//      default:
//        return Container();
//        break;
//    }
//  }
//
//  Widget drawerContainer(){
//    //el drawer es variable, solo se muestra cuando esta en la vista de usuario logeado
//    switch (_selectedIndex) {
//      case 2:
//        if( widget.logeado ){
//          return HomeHeaderUsuarioDraw();
//        } else {
//          return null;
//        }
//        break;
//      default:
//        return null;
//        break;
//    }
//  }



}