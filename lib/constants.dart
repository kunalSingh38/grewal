import 'package:flutter/material.dart';

//dev url
const String BASE_URL = "salesleader.in";
const String API_PATH = "/grewal/public/api";
// const String URL = "https://dev.techstreet.in/grewal/api/";
// https://salesleader.in/grewal/public/api/
const String ALERT_DIALOG_TITLE = "Alert";

//live url
// const String BASE_URL = "www.grewaleducation.com";
// const String API_PATH = "/admin/api";
// const String URL = "https://www.grewaleducation.com/admin/api/";
const String PLAY_STORE_VERSION_LINK =
    "https://play.google.com/store/apps/details?id=com.grewal.grewal";
const kDarkWhite = Colors.white;

final String path = 'assets/images/';
final List<Draw> drawerItems = [
  Draw(title: 'Home'),
  Draw(title: 'Profile'),
  Draw(title: 'Performance'),
  Draw(title: 'MCQs'),
/*  Draw(title: 'Privacy Policy'),
  Draw(title: 'Refund Policy'),
  Draw(title: 'Terms and Conditions'),x
  Draw(title: 'Settings'),*/
];

class Draw {
  final String title;
  Draw({required this.title});
}
