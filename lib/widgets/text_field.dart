import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeautifulTextField extends StatefulWidget {
  final TextEditingController _textController;

  BeautifulTextField(this._textController);

  @override
  BeautifulTextFieldState createState() => BeautifulTextFieldState(_textController);
}

// ignore: non_constant_identifier_names

class BeautifulTextFieldState extends State<BeautifulTextField> {
  final TextEditingController _textController;

  BeautifulTextFieldState(this._textController);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).size.height * 0.12, 10, 0),
        child: Container(
          //height: 100,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _textController,
            style: GoogleFonts.ubuntu(
                fontSize: 17,
                height: 1.5
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              focusedBorder: OutlineInputBorder(
                // borderSide: BorderSide(
                //  color: Colors.black,
                //),
                borderRadius: BorderRadius.circular(5.0),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)
              ),
              labelText: 'Enter youtube video URL',
              labelStyle: GoogleFonts.ubuntu(
                  color: Colors.black54,
                  fontSize: 17
              ),
              //errorText: "Ooops, you didn't enter anything",
            ),
          ),
        )
    );
  }
}