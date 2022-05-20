import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stpwcheckin/utility/my_style.dart';
import 'package:stpwcheckin/models/user_model.dart';
import 'package:stpwcheckin/models/checkin_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:scan_preview/scan_preview_widget.dart';

import '../location/location.dart';

// import '../location/permission_status.dart';
// import '../location/change_notification.dart';
// import '../location/get_location.dart';
// import '../location/listen_location.dart';
// import '../location/service_enabled.dart';

class Home extends StatefulWidget {
  final UserModel userModel;

  Home({Key key, this.userModel}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel myUserModel;
  CheckinModel checkinModel;

  final Location location = Location();

  LocationData _location;
  bool _loading = false;
  String _error;
  String qrString;
  int showCountindate = 0;
  String txtname = '';

  // Method
  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
    getdataCheckin();
  }

  Future<void> getdataCheckin() async {
    int memberId = myUserModel.id;
    String url =
        'http://www.vaiwits.com/stpwcheckin/api/json_data_checkin_today.php?memberID=$memberId';
    // print('url = $url');
    http.Response response = await http.get(url);
    var result = json.decode(response.body);

    setState(() {
      int statusInt = result['status'];

      Map<String, dynamic> map = result['data'];
      CheckinModel lastcheckinModel = CheckinModel.fromJson(map);
      showCountindate = lastcheckinModel.sqindate;
    });
  }

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final LocationData _locationResult = await location.getLocation();
      setState(() {
        _location = _locationResult;
        double lat = _location.latitude;
        double lng = _location.longitude;
        print('Location >> $_location');
        print('LAT :: $lat');
        print('LONG :: $lng');
        _loading = false;

        // Save location to database
        confirmCheckin();
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _loading = false;
      });
    }
  }

  void confirmCheckin() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm check in'),
            content: Text('ยืนยันการเข้าส่งของ'),
            actions: <Widget>[
              cancelButton(),
              comfirmButton(),
            ],
          );
        });
  }

  Widget profileBox() {
    String login = myUserModel.subject;
    int loginStatus = myUserModel.status;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.lightBlue.shade50,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Container(
                      width: 45.0,
                      child: Image.asset('images/icon_user.png'),
                      padding: EdgeInsets.all(8.0),
                    ),
                    Text(
                      '$login', // 'ผู้แทน : $login',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                Text(
                  'วันนี้ส่งของไปแล้วจำนวน $showCountindate จุด', // 'ผู้แทน : $login',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click profile');
          // routeToListProduct(0);
        },
      ),
    );
  }

  Widget cancelButton() {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget comfirmButton() {
    return FlatButton(
      child: Text('Confirm'),
      onPressed: () {
        submitCheckin();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> submitCheckin() async {
    String memberID = myUserModel.id.toString();
    double lat = _location.latitude;
    double lng = _location.longitude;

    String url =
        'http://www.vaiwits.com/stpwcheckin/api/json_submit_checkin.php?lat=$lat&lng=$lng&memberID=$memberID';
    await http.get(url).then((response) {});
  }

  Widget myCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget okButton(BuildContext buildContext) {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(buildContext).pop(); // pop คือการทำให้มันหายไป
      },
    );
  }

///////////////////////////////  QR  //////////////////////////////////////
  Future<void> readQRcodePreview() async {
    try {
      final qrScanString = await Navigator.push(this.context,
          MaterialPageRoute(builder: (context) => ScanPreviewPage()));
      print('readQRcodePreview result: $qrScanString');
      if (qrScanString != null) {
        int memberID = myUserModel.id;
        String urlCheck =
            'http://www.vaiwits.com/stpwcheckin/api/json_data_checkin.php?memberID=$memberID&code=$qrScanString';
        print('urlCheck = $urlCheck');
        http.Response response = await http.get(urlCheck);
        var resultCheck = json.decode(response.body);
        int statusCheck = resultCheck['status'];
        String message = resultCheck['message'];

        if (statusCheck == 0) {
          print('resultCheck = $resultCheck');
          print('statusCheck = $statusCheck');
          print('message = $message');
          normalDialog(context, 'ข้อมูลไม่ถูกต้อง', message);
        } else if (statusCheck == 1) {
          // confirmScanCheckin(qrScanString);
          submitScanCheckin(qrScanString);
        }
      }
    } on PlatformException catch (e) {
      print('e = $e');
    }
  }

  Future<void> txtQRcodePreview(txtname) async {
    try {
      final qrScanString = txtname;
      print('readQRcodePreview result: $qrScanString');
      if (qrScanString != null) {
        int memberID = myUserModel.id;
        String urlCheck =
            'http://www.vaiwits.com/stpwcheckin/api/json_data_checkin.php?memberID=$memberID&code=$qrScanString';
        print('urlCheck = $urlCheck');
        http.Response response = await http.get(urlCheck);
        var resultCheck = json.decode(response.body);
        int statusCheck = resultCheck['status'];
        String message = resultCheck['message'];

        if (statusCheck == 0) {
          print('resultCheck = $resultCheck');
          print('statusCheck = $statusCheck');
          print('message = $message');
          normalDialog(context, 'ข้อมูลไม่ถูกต้อง', message);
        } else if (statusCheck == 1) {
          // confirmScanCheckin(qrScanString);
          submitScanCheckin(qrScanString);
        }
      }
    } on PlatformException catch (e) {
      print('e = $e');
    }
  }

  void confirmScanCheckin(var code) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm check in'),
            content: Text('ยืนยันการเข้าส่งของ'),
            actions: <Widget>[
              cancelScanButton(),
              comfirmScanButton(code),
            ],
          );
        });
  }

  Widget cancelScanButton() {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget comfirmScanButton(code) {
    return FlatButton(
      child: Text('Confirm'),
      onPressed: () {
        submitScanCheckin(code);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> submitScanCheckin(code) async {
    String memberID = myUserModel.id.toString();

    final LocationData _locationResult = await location.getLocation();
    _location = _locationResult;
    double lat = _location.latitude;
    double lng = _location.longitude;
    print('decodeQRcode');
    print('Location >> $_location');
    print('LAT :: $lat');
    print('LONG :: $lng');
    _loading = false;
    String url =
        'http://www.vaiwits.com/stpwcheckin/api/json_submit_scan_checkin.php?code=$code&lat=$lat&lng=$lng&memberID=$memberID';
    print(url);
    await http.get(url).then((response) {
      setState(() {
        getdataCheckin();
      });
    });
    final snackBar = SnackBar(
      content: Text('เพิ่มตำแหน่งการส่งสินค้าเรียบร้อย'),
      margin: EdgeInsets.all(20),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.blue,
      elevation: 50,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

///////////////////////////////  QR  //////////////////////////////////////

  Widget showTitle(String title) {
    return ListTile(
      leading: Icon(
        Icons.android,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Future<void> normalDialog(
    BuildContext buildContext,
    String title,
    String message,
  ) async {
    showDialog(
      context: buildContext,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: showTitle(title),
          content: Text(message),
          actions: <Widget>[okButton(buildContext)],
        );
      },
    );
  }

  Widget formBox() {
    var _controller = TextEditingController();

    return Card(
      child: Container(
        // decoration: MyStyle().boxLightGreen,
        width: MediaQuery.of(context).size.width * 0.80,
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Column(
                children: <Widget>[
                  // Text('code :'),
                  // mySizebox(),
                  Text(
                    'สแกนด้วยเครื่อง',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  mySizebox(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onSubmitted: (value) {
                        txtQRcodePreview(value);
                        _controller.clear();
                      },
                      style: TextStyle(color: Colors.black),
                      // initialValue: complainAllModel.postby, // set default value
                      onChanged: (string) {
                        txtname = string.trim();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 6.0,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _controller.clear,
                          icon: Icon(Icons.clear),
                        ),
                        // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
                        // border: InputBorder.none,
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnScanCheckin() {
    // all product
    return Container(
      // width: MediaQuery.of(context).size.width * 0.45,
      width: 150.0,
      height: 150.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'สแกนด้วยกล้อง',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                mySizebox(),
                Container(
                  width: 70.0,
                  child: Image.asset('images/barcode.png'),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          // _getLocation();
          readQRcodePreview();
        },
      ),
    );
  }

  Widget mySizebox() {
    return SizedBox(
      width: 10.0,
      height: 10.0,
    );
  }

  Widget headTitle(String string, IconData iconData) {
    // Widget  แทน object ประเภทไดก็ได้
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Icon(
            iconData,
            size: 24.0,
            color: MyStyle().textColor,
          ),
          mySizebox(),
          Text(
            string,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: MyStyle().textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          headTitle('ข้อมูลของคุณ', Icons.verified_user),
          profileBox(),
          headTitle('เมนู', Icons.home),
          formBox(),
          btnScanCheckin(),
          // btnCheckin(),
          mySizebox(),
        ],
      ),
    );
  }
}

class ScanPreviewPage extends StatefulWidget {
  @override
  _ScanPreviewPageState createState() => _ScanPreviewPageState();
}

class _ScanPreviewPageState extends State<ScanPreviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('STPW checkin'),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ScanPreviewWidget(
            onScanResult: (result) {
              debugPrint('scan result: $result');
              Navigator.pop(context, result);
            },
          ),
        ),
      ),
    );
  }
}
