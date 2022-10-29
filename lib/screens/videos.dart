import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideosLink extends StatefulWidget {
  @override
  _VideosLinkState createState() => _VideosLinkState();
}

class _VideosLinkState extends State<VideosLink> {
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Image(
            image: AssetImage("assets/images/Icon.png"),
            height: 20.0,
            width: 10.0,
            color: Color(0xff2E2A4A),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        centerTitle: true,
        title: Container(
          child: Text("List of Videos", style: normalText6),
        ),
        flexibleSpace: Container(
          height: 100,
          color: Color(0xffffffff),
        ),
        // actions: <Widget>[
        //   Align(
        //     alignment: Alignment.center,
        //     child: CircleAvatar(
        //       backgroundColor: Colors.white,
        //       radius: 30,
        //       child: _networkImage1(
        //         profile_image,
        //       ),
        //     ),
        //   ),
        // ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
