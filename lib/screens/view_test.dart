import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/CustomRadioWidget.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/models/xml_json.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ViewMCQ extends StatefulWidget {
  final Object argument;

  const ViewMCQ({required this.argument});

  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<ViewMCQ> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final chapterController = TextEditingController();

  bool showDrop = false;
  bool _loading = false;
  bool _isHidden = true;
  bool isEnabled1 = true;

  bool isEnabled2 = false;

  Future<Map>? _quiz;
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String user_id = "";
  String class_id = "";
  String board_id = "";

  String test_id = "";

  var answerId;
  bool lastAns = false;
  bool done = false;

  List<XMLJSON> xmlList = [];

  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    test_id = data['test_id'];

    _getUser();
  }

  String api_token = "";
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        class_id = prefs.getString('class_id').toString();
        board_id = prefs.getString('board_id').toString();
        api_token = prefs.getString('api_token').toString();
        _quiz = _getTestData();
      });
    });
  }

  Future<Map> _getTestData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    print(api_token);
    print(Uri.https(BASE_URL, API_PATH + "/check-result"));

    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/check-result"),
      body: {"test_id": test_id, "user_id": user_id},
      headers: headers,
    );
    print(jsonEncode({"test_id": test_id, "user_id": user_id}));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List te = data['Response'];
      arr = List.generate(te.length, (index) => 0);

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  var currentTime;

  int id = 0;
  List<int>? arr;
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Color(0xff2E2A4A),
      letterSpacing: 1);
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));

  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));

  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  bool full_show = false;

  CarouselController buttonCarouselController = CarouselController();

  Widget _customContent(Size deviceSize) {
    return FutureBuilder(
      future: _quiz,
      builder: (context, snapshot) {
        var getScreenHeight = MediaQuery.of(context).size.height;
        if (snapshot.connectionState == ConnectionState.done) {
          Map map = snapshot.data as Map;
          var errorCode = map['ErrorCode'];
          List response = map['Response'];
          if (errorCode == 0) {
            return response.length != 0
                ? CarouselSlider.builder(
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      height: getScreenHeight,
                      initialPage: 0,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      //  aspectRatio: 1,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      reverse: false,
                      // autoPlay: false,
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: response.length,
                    itemBuilder: (context, itemIndex, realIndex) {
                      List paraList = [];
                      List tablesList = [];
                      if (response[itemIndex]['question']
                          .toString()
                          .contains("p")) {
                        print("inside");
                        final document =
                            parse(response[itemIndex]['question'].toString());

                        var para = document.querySelectorAll('p');
                        para.forEach((element) {
                          paraList.add(element.outerHtml);
                        });

                        var para1 = document.querySelectorAll('table');
                        para1.forEach((element) {
                          tablesList.add(element.outerHtml);
                        });
                      }
                      return SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 70,
                          ),
                          Container(
                            child: Image.asset(
                              'assets/images/question.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          response[itemIndex]['final_result'] == "R"
                              ? CircleAvatar(
                                  backgroundColor: Color(0xff51DEA0),
                                  radius: 40,
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Color(0xffF45656),
                                  radius: 40,
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          response[itemIndex]['comprahensive_paragraph ']
                                  .toString()
                                  .contains("<")
                              ? Container(
                                  color: Color(0xffF9F9FB),
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 10, bottom: 10),
                                  child: HtmlWidget(
                                      response[itemIndex]
                                              ['comprahensive_paragraph ']
                                          .toString()
                                          .toString(),
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15)),
                                )
                              : response[itemIndex]
                                          ['comprahensive_paragraph '] ==
                                      null
                                  ? SizedBox()
                                  : Container(
                                      color: Color(0xffF9F9FB),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 10,
                                          bottom: 10),
                                      child: Text(
                                          response[itemIndex]
                                              ['comprahensive_paragraph '],
                                          textAlign: TextAlign.justify,
                                          // maxLines: 100,
                                          // overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700)),
                                    ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Color(0xffF9F9FB),
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 20),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Q.No. ' + (itemIndex + 1).toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                paraList.length == 0
                                    ? HtmlWidget(
                                        response[itemIndex]['question']
                                            .toString(),
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15),
                                      )
                                    : SizedBox(),
                                paraList.isEmpty
                                    ? SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: paraList
                                            .map((e) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: HtmlWidget(
                                                    e,
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15),
                                                  ),
                                                ))
                                            .toList()),
                                tablesList.isEmpty
                                    ? SizedBox()
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: tablesList
                                                .map((e) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: HtmlWidget(
                                                        e,
                                                        textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 15),
                                                      ),
                                                    ))
                                                .toList()),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          response[itemIndex]['question_type'] == "True False"
                              ? response[itemIndex]['final_result'] == "R"
                                  ? Column(children: <Widget>[
                                      response[itemIndex]['option_first'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_first_color'] !=
                                                          ""
                                                      ? Color(0xff51DEA0)
                                                      : Color(0xffF9F9FB),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_first'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_first'],
                              maxLines: 100,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                      response[itemIndex]['option_second'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_second_color'] !=
                                                          ""
                                                      ? Color(0xff51DEA0)
                                                      : Color(0xffF9F9FB),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_second'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /* Text(
                              response[itemIndex]
                              ['option_second'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                    ])
                                  : Column(children: <Widget>[
                                      response[itemIndex]['option_first'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_first_color'] ==
                                                          ""
                                                      ? Color(0xffF9F9FB)
                                                      : response[itemIndex][
                                                                  'option_first_color'] !=
                                                              "green"
                                                          ? Color(0xffF45656)
                                                          : Color(0xff51DEA0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_first'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_first'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                      response[itemIndex]['option_second'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_second_color'] ==
                                                          ""
                                                      ? Color(0xffF9F9FB)
                                                      : response[itemIndex][
                                                                  'option_second_color'] !=
                                                              "green"
                                                          ? Color(0xffF45656)
                                                          : Color(0xff51DEA0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_second'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_second'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                    ])
                              : response[itemIndex]['final_result'] == "R"
                                  ? Column(children: <Widget>[
                                      response[itemIndex]['option_first'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_first_color'] !=
                                                          ""
                                                      ? Color(0xff51DEA0)
                                                      : Color(0xffF9F9FB),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_first'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_first'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                      response[itemIndex]['option_second'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_second_color'] !=
                                                          ""
                                                      ? Color(0xff51DEA0)
                                                      : Color(0xffF9F9FB),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_second'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_second'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                      response[itemIndex]['option_third'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_third_color'] !=
                                                          ""
                                                      ? Color(0xff51DEA0)
                                                      : Color(0xffF9F9FB),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_third'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_third'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                      response[itemIndex]['option_fourth'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_fourth_color'] !=
                                                          ""
                                                      ? Color(0xff51DEA0)
                                                      : Color(0xffF9F9FB),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_fourth'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_fourth'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                    ])
                                  : Column(children: <Widget>[
                                      response[itemIndex]['option_first'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_first_color'] ==
                                                          ""
                                                      ? Color(0xffF9F9FB)
                                                      : response[itemIndex][
                                                                  'option_first_color'] !=
                                                              "green"
                                                          ? Color(0xffF45656)
                                                          : Color(0xff51DEA0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_first'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_first'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                      response[itemIndex]['option_second'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_second_color'] ==
                                                          ""
                                                      ? Color(0xffF9F9FB)
                                                      : response[itemIndex][
                                                                  'option_second_color'] !=
                                                              "green"
                                                          ? Color(0xffF45656)
                                                          : Color(0xff51DEA0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_second'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_second'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                      response[itemIndex]['option_third'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_third_color'] ==
                                                          ""
                                                      ? Color(0xffF9F9FB)
                                                      : response[itemIndex][
                                                                  'option_third_color'] !=
                                                              "green"
                                                          ? Color(0xffF45656)
                                                          : Color(0xff51DEA0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_third'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_third'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                      response[itemIndex]['option_fourth'] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: response[itemIndex][
                                                              'option_fourth_color'] ==
                                                          ""
                                                      ? Color(0xffF9F9FB)
                                                      : response[itemIndex][
                                                                  'option_fourth_color'] !=
                                                              "green"
                                                          ? Color(0xffF45656)
                                                          : Color(0xff51DEA0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Html(
                                                data: response[itemIndex]
                                                    ['option_fourth'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                        HtmlPaddings.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ) /*Text(
                              response[itemIndex]
                              ['option_fourth'],
                              maxLines: 3,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: normalText5)*/
                                              ,
                                            ),
                                    ]),
                          const SizedBox(
                            height: 10,
                          ),
                          lastAns != true
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                      Align(
                                        alignment: FractionalOffset.bottomRight,
                                        child: ButtonTheme(
                                          minWidth: 50.0,
                                          height: 34.0,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: ElevatedButton(
                                                // padding:
                                                // const EdgeInsets.only(
                                                //     top: 2,
                                                //     bottom: 2,
                                                //     left: 25,
                                                //     right: 25),
                                                // shape: RoundedRectangleBorder(
                                                //     borderRadius:
                                                //     BorderRadius.circular(
                                                //         25.0)),
                                                // textColor: Colors.white,
                                                // color: Color(0xff017EFF),
                                                onPressed: () async {
                                                  onPreviousClick();
                                                },
                                                child: Text(
                                                  "Previous",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: FractionalOffset.bottomRight,
                                        child: ButtonTheme(
                                          minWidth: 50.0,
                                          height: 34.0,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: ElevatedButton(
                                                // padding:
                                                //     const EdgeInsets
                                                //             .only(
                                                //         top: 2,
                                                //         bottom: 2,
                                                //         left: 25,
                                                //         right: 25),
                                                // shape: RoundedRectangleBorder(
                                                //     borderRadius:
                                                //         BorderRadius
                                                //             .circular(
                                                //                 25.0)),
                                                // textColor: Colors.white,
                                                // color:
                                                //     Color(0xff017EFF),
                                                onPressed: () async {
                                                  XMLJSON xmljson = new XMLJSON(
                                                      answer: '',
                                                      question: '',
                                                      time_taken: '');

                                                  if (itemIndex ==
                                                      (response.length - 1)) {
                                                    setState(() {
                                                      lastAns = true;
                                                    });
                                                  }
                                                  onNextClick();
                                                },
                                                child: Text(
                                                  "Next",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])
                              : Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: ButtonTheme(
                                    minWidth: 50.0,
                                    height: 34.0,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 20),
                                        child: ElevatedButton(
                                          // padding:
                                          //     const EdgeInsets.only(
                                          //         top: 2,
                                          //         bottom: 2,
                                          //         left: 25,
                                          //         right: 25),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(
                                          //             25.0)),
                                          // textColor: Colors.white,
                                          // color: Color(0xff017EFF),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            Navigator.pushNamed(
                                                context, '/dashboard');
                                          },
                                          child: Text(
                                            "Go To Dashboard",
                                            style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: deviceSize.width,
                            decoration: new BoxDecoration(
                                color: Color(0xffF9F9FB),
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                    bottomRight: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0))),
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20),
                            child: Column(children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child: Text("Reason:", style: normalText6),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              /* response[itemIndex]
                                  ['reason'].contains("<")?*/
                              Container(
                                child: Html(
                                  data: response[itemIndex]['reason'],
                                  style: {
                                    "table": Style(
                                      backgroundColor: Color.fromARGB(
                                          0x50, 0xee, 0xee, 0xee),
                                    ),
                                    "tr": Style(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                    "th": Style(
                                      padding: HtmlPaddings.all(6),
                                      backgroundColor: Colors.grey,
                                    ),
                                    "td": Style(
                                      padding: HtmlPaddings.all(6),
                                      alignment: Alignment.topLeft,
                                    ),
                                    'h5': Style(
                                        maxLines: 2,
                                        textOverflow: TextOverflow.ellipsis),
                                  },
                                ),
                              ) /*:  Container(
                                    child: Text(
                                        response[itemIndex]
                                        ['reason'],
                                        textAlign: TextAlign.justify,
                                        style: normalText5),
                                  )*/
                            ]),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  '${itemIndex + 1}/15',
                                  style: normalText6,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ]),
                      );
                    })
                : Container();
          } else {
            return Container();
          }
        } else {
          return Center(
              child: Align(
            alignment: Alignment.center,
            child: Container(
              child: SpinKitFadingCube(
                itemBuilder: (_, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color:
                          index.isEven ? Color(0xff017EFF) : Color(0xffFFC700),
                    ),
                  );
                },
                size: 30.0,
              ),
            ),
          ));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    print("check-----");
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Stack(
          children: [
            Image(
              image: AssetImage('assets/images/Vector6.png'),
              // fit: BoxFit.fill,
            ),
            _customContent(deviceSize),
          ],
        ),
      ),
    );
  }

  onNextClick() {
    buttonCarouselController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  onPreviousClick() {
    buttonCarouselController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }
}
