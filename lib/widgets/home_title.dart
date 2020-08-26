import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTitle extends StatelessWidget {
  final color = Color(0xFFEEEEEE);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
        Text('CCHUB', style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 60,
            color: color,
            shadows: <Shadow>[
              Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 10.0,
                  color: Colors.teal
              )
            ]
        ), textAlign: TextAlign.center,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('YOUR ASSISTANT FOR SEARCHING & DOWNLOADING CLOSED CAPTIONS OF YOUTUBE VIDEO', maxLines: 3, style: GoogleFonts.ubuntuMono(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
              shadows: <Shadow>[
                Shadow(
                    offset: Offset(0, 2.0),
                    blurRadius: 1.0,
                    color: Colors.teal
                )
              ]
          ),textAlign: TextAlign.center,),
        ),
      ],
    );
  }
}