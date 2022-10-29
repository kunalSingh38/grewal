import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class SupportList extends StatefulWidget {
  final String modal;

  SupportList(this.modal);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SupportList> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  final completeController = TextEditingController();

  String user_id = "";
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String profile_image = '';
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";

  @override
  void initState() {
    super.initState();

    _getUser();
  }
  String api_token = "";
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        order_id = prefs.getString('order_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        api_token = prefs.getString('api_token').toString();
        _chapterData = _getChapterData();
      });
    });
  }

  Widget _networkImage1(url) {
    return Container(
      margin: EdgeInsets.only(
        right: 8,
        left: 8,
      ),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffffffff),
        image: DecorationImage(
          image: NetworkImage(profile_image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }

  Future _getChapterData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/student_support_list"),
      body: {

          "student_id":user_id

      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);


      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }







  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['Response'] != null) {
            return Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data['Response'].length,
                  itemBuilder: (context, index) {
                    return  InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/support-detail',
                            arguments: <String, String>{
                              'support_id':  snapshot.data['Response']
                              [index]['id'].toString(),
                            },
                          );
                        },
                        child: Column(children: <Widget>[
                          Stack(children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              color: Color(0xffF9F9FB),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        //  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                        height: 50,
                                        width: 50,
                                        decoration: new BoxDecoration(
                                          // color: Color(0xffF6F6F6),
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                const Radius.circular(5.0),
                                                bottomLeft:
                                                const Radius.circular(5.0),
                                                bottomRight:
                                                const Radius.circular(5.0),
                                                topRight: const Radius.circular(
                                                    5.0))),
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xff017EFF),
                                          radius: 40,
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/out_support.png',
                                            ),
                                            height: 22.0,
                                            width: 22.0,
                                            color: Colors.white,
                                          ),
                                        ),

                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                    snapshot.data['Response']
                                                    [index]['subject'],
                                                    maxLines: 1,
                                                    softWrap: true,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: normalText5),
                                              ),
                                            ],
                                          ),
                                          Container(
                                              child: Text(
                                                  snapshot.data['Response'][index]
                                                  ['message'],
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: normalText7),
                                            ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Icon(
                                      Icons.arrow_right,
                                      color: Color(0xff017EFF),
                                      size: 20,
                                    )
                                  ]),
                            ),
                            /*  snapshot.data['Response']
                                [index]['is_taken']==0? Positioned(
                                  child: myPopMenu(snapshot.data['Response'][index]
                                          ['id']
                                      .toString()),
                                  right: -5,
                                  top: -5,

                                ):Container(),*/
                          ]),

                          /*   new Container(
                                      padding: EdgeInsets.only(left: 40,right: 10),
                                      child: Divider(
                                        color: Color(0xffE8E8E8),
                                        thickness: 1,
                                      )),*/
                        ]),
                      );


                  }),
            );
          } else {
            return _emptyOrders();
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
                          color: index.isEven ? Color(0xff017EFF) :Color(0xffFFC700),
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

  Widget _emptyOrders() {
    return Center(
      child: Container(
          child: Text(
            'NO SUPPORT LIST FOUND!',
            style:
            TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.modal != ""?AppBar(
          elevation: 0.0,
          leading: widget.modal != ""? Row(children: <Widget>[
            IconButton(
              icon: Image(
                image: AssetImage("assets/images/Icon.png"),
                height: 20.0,
                width: 10.0,
                color: Color(0xff2E2A4A),
              ),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),

          ]):Row(children: <Widget>[
            IconButton(
              icon: Image(
                image: AssetImage("assets/images/list_icon.png"),
                height: 20.0,
                width: 10.0,
                color: Color(0xff2E2A4A),
              ),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),

          ]),
          centerTitle: true,
          title: Container(
            child: Text("Support", style: normalText6),
          ),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffffffff),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: _networkImage1(
                  profile_image,
                ),
              ),
            ),
          ],
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ):null,
        floatingActionButton: widget.modal != ""? Container(

          child:  FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add-support',

              );
            },
            backgroundColor:Color(0xff017EFF),
            label: Text("Create"),
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
        ):Container()
           ,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.02,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                  /*  Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: new TextField(
                                enabled: true,
                                controller: completeController,
                                decoration: InputDecoration(
                                  fillColor: Color(0xfff9f9fb),
                                  filled: true,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(10, 30, 30, 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  counterText: "",
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xff200E32),
                                    size: 24,
                                  ),
                                  hintStyle: TextStyle(
                                      color: Color(0xffBBBFC3), fontSize: 16),
                                  hintText: 'Search your tests... ',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                textCapitalization: TextCapitalization.none,
                              ),
                            ),
                          ),
                        ),
                        *//* SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          height: 15,
                          child: Image(
                              image: AssetImage('assets/images/filter.png'),
                              height: 15,
                              width: 15,
                              fit: BoxFit.fill),
                        ),*//*
                      ]),
                    ),*/
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: chapterList(deviceSize),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              )),
        ));
  }
}
