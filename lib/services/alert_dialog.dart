import 'package:flutter/material.dart';

void errorDialog(int i, BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 50),
        title: new Text("Error!", style: TextStyle(
            color: Colors.red
        ),),
        content: i == 1? Text("Perhaps you forgot to enter URL or entered the wrong one") : Text("The video doesn't contain any subtitles"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close", style: TextStyle(
                color: Colors.red
            ),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}