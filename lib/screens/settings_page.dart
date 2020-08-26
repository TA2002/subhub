import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_captions/style.dart';
import '../services/shared_pref.dart';


class SettingsScreen extends StatefulWidget {
  final callback;

  SettingsScreen(this.callback);

  @override
  _SettingsScreenState createState() => _SettingsScreenState(callback);
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  bool darkMode = true;
  final callback;

  _SettingsScreenState(this.callback);

  @override

  setMode() async {
    var tempMode = await readDarkMode();
    setState(() {
      darkMode = tempMode;
    });
    widget.callback(darkMode);
  }

  saveMode(var value) async {
    writeDarkMode(value);
  }

  void initState() {
    super.initState();
    setMode();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
      appBar: AppBar(title: Text('Settings', style: AppTheme.appBar), centerTitle: true,
        backgroundColor: darkMode? Colors.black : Colors.white,
      ),
      backgroundColor: darkMode? Colors.black.withOpacity(0.9) : Colors.white10,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(child: Text('Theme',
              style: AppTheme.subtitleTile.copyWith(color: Colors.deepOrange),
            ), padding: EdgeInsets.only(top: 25, left: 20),),
            ListTile(
              leading: Icon(Icons.lightbulb_outline,
                color: darkMode? Colors.white.withOpacity(0.9) : Colors.black54
              ),
              title: Text('Dark mode',
                style: darkMode? AppTheme.settingsDark : AppTheme.settingsLight,
              ),
              trailing: CupertinoSwitch(
                value: darkMode,
                activeColor: Colors.deepOrange,
                onChanged: (value){
                  setState(() {
                    darkMode = value;
                    saveMode(value);
                    widget.callback(darkMode);
                  });
                },
              ),

            ),
            Padding(child: Text('Storage', style: AppTheme.subtitleTile.copyWith(color: Colors.deepOrange),), padding: EdgeInsets.only(top: 10, left: 20),),
            ListTile(
              leading: Icon(Icons.favorite_border,
                color: darkMode? Colors.white.withOpacity(0.9) : Colors.black54,
              ),
              title: Text('Clear favorite',
                style: darkMode? AppTheme.settingsDark : AppTheme.settingsLight,
              ),
              onTap: (){
                List<String> empty = [];
                writeLikedVideos(empty);
                Scaffold.of(context).showSnackBar(

                    SnackBar(content: Text('Favorite cleared'))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: darkMode? Colors.white.withOpacity(0.9) : Colors.black54,),
              title: Text('Clear history', style: darkMode? AppTheme.settingsDark : AppTheme.settingsLight,),
              onTap: (){
                List<String> empty = [];
                writeUrl(empty);
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('History cleared'))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: darkMode? Colors.white.withOpacity(0.9) : Colors.black54,),
              title: Text('Clear search suggestion', style: darkMode? AppTheme.settingsDark : AppTheme.settingsLight,),
              onTap: (){
                List<String> empty = [];
                writeRecentSuggestions(empty);
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Search suggestions cleared'))
                );
              },
            ),
          ],
        ),
      )
    );
  }
}

