import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/api/data_list.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ModelTestPaperNewList extends StatefulWidget {
  @override
  _ModelTestPaperNewListState createState() => _ModelTestPaperNewListState();
}

class _ModelTestPaperNewListState extends State<ModelTestPaperNewList> {
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  String email_id = "";
  String _mobile = "";
  String user_id = "";
  String order_id = "";

  bool isLoading = true;
  List testLinks = [];
  bool payment2Status = false;
  Future<void> getPaymentStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      payment2Status =
          prefs.getString("payment2").toString() == "1" ? true : false;
      email_id = prefs.getString('email_id').toString();
      _mobile = prefs.getString('mobile_no').toString();
      user_id = prefs.getString('user_id').toString();
      order_id = prefs.getString('order_id').toString();
      print(payment2Status);
    });
  }

  ExpandableController contr = ExpandableController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataListOfSubjects().getModelTestPaperPDF().then((value) {
      if (value.length > 0) {
        setState(() {
          testLinks.clear();
          testLinks.addAll(value);
          print(testLinks);
        });
      }
    });
    getPaymentStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          child: Row(children: <Widget>[
            IconButton(
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
          ]),
        ),
        centerTitle: true,
        title: Text("Model Test Paper Series", style: normalText6),
        flexibleSpace: Container(
          height: 100,
          color: Color(0xffffffff),
        ),
        actions: <Widget>[
          /*Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: _networkImage1(
                profile_image,
              ),
            ),
          ),*/
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: testLinks.length == 0
            ? Center(
                child: Text("No model test paper series available"),
              )
            : SingleChildScrollView(
                child: Column(
                  children: testLinks.map((e) {
                    return Card(
                      color: Color(0xFFFFFFFF),
                      borderOnForeground: true,
                      elevation: 10,
                      child: ExpandableNotifier(
                        child: ExpandablePanel(
                          header: ListTile(
                            title: Text(e['que_paper_name']
                                .toString()
                                .replaceFirst(" Question", "")),
                            minLeadingWidth: 2,
                            leading: e['paid'] == 1
                                ? SizedBox(
                                    width: 22,
                                  )
                                : payment2Status
                                    ? Icon(
                                        Icons.lock_open,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),
                            subtitle: Text(
                              "Series " + e['series'].toString(),
                            ),
                          ),
                          theme: ExpandableThemeData(
                            animationDuration: Duration(milliseconds: 400),
                          ),
                          expanded: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (e['paid'] == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TestSeriesPDF(
                                                  url:
                                                      e['que_paper'].toString(),
                                                  topicName: e['que_paper_name']
                                                      .toString(),
                                                )),
                                      );
                                    } else {
                                      if (payment2Status) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TestSeriesPDF(
                                                    url: e['que_paper']
                                                        .toString(),
                                                    topicName:
                                                        e['que_paper_name']
                                                            .toString(),
                                                  )),
                                        );
                                      } else {
                                        Navigator.pushNamed(
                                          context,
                                          '/plan',
                                          arguments: <String, String>{
                                            'order_id': order_id.toString(),
                                            'signupid': user_id.toString(),
                                            'mobile': _mobile.toString(),
                                            'email': email_id.toString(),
                                            'out': 'in'
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 30.0,
                                        top: 20.0,
                                        right: 10,
                                        bottom: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: planbg1,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(color: planbg1)),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            top: 10.0,
                                            right: 10,
                                            bottom: 10),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 26.0),
                                              child: Center(
                                                child: Container(
                                                  width: 78,
                                                  height: 67.01,
                                                  child: new Image.asset(
                                                      'assets/images/lightbulb.png'),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 14.76),
                                              child: Center(
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Test Series \n  \n",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (e['paid'] == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TestSeriesPDF(
                                                  url: e['ans_key'].toString(),
                                                  topicName: e['ans_key_name']
                                                      .toString(),
                                                )),
                                      );
                                    } else {
                                      if (payment2Status) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TestSeriesPDF(
                                                    url:
                                                        e['ans_key'].toString(),
                                                    topicName: e['ans_key_name']
                                                        .toString(),
                                                  )),
                                        );
                                      } else {
                                        Navigator.pushNamed(
                                          context,
                                          '/plan',
                                          arguments: <String, String>{
                                            'order_id': order_id.toString(),
                                            'signupid': user_id.toString(),
                                            'mobile': _mobile.toString(),
                                            'email': email_id.toString(),
                                            'out': 'in'
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20.0,
                                        right: 30,
                                        bottom: 20),
                                    child: Container(
                                      /* width: 151,
                                  height: 176,*/
                                      decoration: BoxDecoration(
                                          color: planbg1,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(color: planbg1)),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            top: 10.0,
                                            right: 10,
                                            bottom: 10),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 26.0),
                                              child: Center(
                                                child: Container(
                                                  width: 78,
                                                  height: 67.01,
                                                  child: new Image.asset(
                                                      'assets/images/problem_solving.png'),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 14.76),
                                              child: Center(
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Answer \n Key \n",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          collapsed: SizedBox(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}

class TestSeriesPDF extends StatefulWidget {
  String url;
  String topicName;
  TestSeriesPDF({required this.url, required this.topicName});
  @override
  _TestSeriesPDFState createState() => _TestSeriesPDFState();
}

class _TestSeriesPDFState extends State<TestSeriesPDF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          child: Row(children: <Widget>[
            IconButton(
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
          ]),
        ),
        centerTitle: true,
        title: Container(
          child: FittedBox(
              child: Text(
            widget.topicName.toString(),
            style: TextStyle(color: Color(0xff2E2A4A)),
          )),
        ),
        actions: <Widget>[
          /*Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: _networkImage1(
                profile_image,
              ),
            ),
          ),*/
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfPdfViewer.network(widget.url.toString()),
      ),
    );
  }
}
