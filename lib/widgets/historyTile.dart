import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryTile extends StatefulWidget {
  final String name;
  final String imageUrl;
  final callback;
  HistoryTile(this.name, this.imageUrl, this.callback);


  @override
  HistoryTileState createState() => HistoryTileState(name, imageUrl, callback);
}

class HistoryTileState extends State<HistoryTile> {
  final String name;
  final String imageUrl;
  final callback;

  HistoryTileState(this.name, this.imageUrl, this.callback);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: GestureDetector(
        onTap: (){
          widget.callback(name);
        },
        child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                width: 150,
                height: 95,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                          color: Colors.white30,
                          width: 1
                      ),
                      left: BorderSide(
                          color: Colors.white30,
                          width: 1
                      ),
                      right: BorderSide(
                          color: Colors.white30,
                          width: 1
                      ),
                      bottom: BorderSide(
                          color: Colors.white30,
                          width: 1
                      ),
                    )
                ),
              ),
              Container(
                width: 150,
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(
                          color: Colors.white30,
                          width: 1.5
                      ),
                      right: BorderSide(
                          color: Colors.white30,
                          width: 1.5
                      ),
                      bottom: BorderSide(
                          color: Colors.white30,
                          width: 1.5
                      ),
                    )
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text('$name', maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.ubuntu(
                        fontSize: 11
                    ),),
                  ),
                )
              ),
            ]
        ),
      ),
    );
  }

}