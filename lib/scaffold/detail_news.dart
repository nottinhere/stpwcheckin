import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stpwcheckin/models/user_model.dart';
import 'package:stpwcheckin/utility/my_style.dart';
import 'package:stpwcheckin/models/news_model.dart';

class DetailNews extends StatefulWidget {
  final NewsModel newsModel;
  final UserModel userModel;

  DetailNews({Key key, this.newsModel, this.userModel}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<DetailNews> {
  // Explicit
  NewsModel currentNewsModel;
  NewsModel newsModel;
  UserModel myUserModel;
  String id; // productID
  String memberID;
  String imageNews = '';
  String subjectNews = '';
  String detailNews = '';
  String postdateNews = '';
  // Method
  @override
  void initState() {
    super.initState();
    currentNewsModel = widget.newsModel;
    myUserModel = widget.userModel;
    setState(() {
      getNewsWhereID();
    });
  }

  Future<void> getNewsWhereID() async {
    String url = 'https://nottinhere.com/demo/stap/api/json_supnewsdetail.php';
    print('urlNews >> $url');

    http.Response response = await http.get(url);
    var result = json.decode(response.body);

    var mapItemNews =
        result['itemsData']; // dynamic    จะส่ง value อะไรก็ได้ รวมถึง null

    for (var map in mapItemNews) {
      NewsModel newsModel = NewsModel.fromJson(map);
      String urlImage = newsModel.photo;
      String subject = newsModel.subject;
      String postdate = newsModel.postdate;
      String detail = newsModel.detail;
      print('subjectNews >> $subject');
      setState(() {
        //promoteModels.add(promoteModel); // push ค่าลง arra
        subjectNews = subject;
        imageNews = urlImage;
        detailNews = detail;
        postdateNews = postdate;
      });
    } // for
  }

  Widget spaceBox() {
    return SizedBox(
      width: 10.0,
      height: 16.0,
    );
  }

  Widget showTitle() {
    return Card(
      child: Column(
        children: <Widget>[
          Text(
            subjectNews,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 56, 80, 82),
            ),
          ),
          SizedBox(
            width: 10.0,
            height: 15.0,
          )
        ],
      ),
    );
  }

  Widget showImage() {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: new EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.network(
              imageNews,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ],
        ),
      ),
    );
  }

  Widget showDetail() {
    return Card(
      child: Container(
        // decoration: MyStyle().boxLightGreen,
        // height: 35.0,
        width: MediaQuery.of(context).size.width * 0.95,
        padding: EdgeInsets.only(left: 10.0, right: 20.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 10.0,
              height: 5.0,
            ),
            Text(
              'โพสเมื่อ :' + postdateNews,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            Text(
              detailNews.replaceAll('\\n', '\n'),
              style: TextStyle(
                fontSize: 19.0,
                // fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          //showCart(),
        ],
        backgroundColor: MyStyle().barColor,
        title: Text('รายละเอียดข่าว'),
      ),
      body: ListView(
        children: <Widget>[
          spaceBox(),
          showTitle(),
          showImage(),
          showDetail(), //  newsModel == null ? showProgress() : detailBox(),
        ],
      ),
    );
  }

  // Widget showProgress() {
  //   return Center(
  //     child: CircularProgressIndicator(),
  //   );
  // }

  // Widget showDetailList() {
  //   return Stack(
  //     children: <Widget>[
  //       showController(),
  //       // addButton(),
  //     ],
  //   );
  // }

  // ListView showController() {
  //   return ListView(
  //     padding: EdgeInsets.all(15.0),
  //     children: <Widget>[
  //       showTitle(),
  //       // showImage(),
  //       detailBox(),

  //       // submitButton(),
  //     ],
  //   );
  // }
}
