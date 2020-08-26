import 'package:flutter/material.dart';

class TextStyleEd extends StatefulWidget {
  TextStyleEd({Key key}) : super(key: key);

  @override
  TextStyleEdState createState() => TextStyleEdState();
}

class TextStyleEdState extends State<TextStyleEd> {
  TextStyle textStyle;
  TextAlign textAlign;


  @override
  initState() {
    textStyle =
        TextStyle(fontSize: 25, color: Colors.black);
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          color: Colors.black,
          height: 40,
          onPressed: (){
            //showAlertDialog();
          },
        ),
      ),
    );
  }
}