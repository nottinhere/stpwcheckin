import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stpwcheckin/utility/my_style.dart';
import 'package:stpwcheckin/models/user_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:scan_preview/scan_preview_widget.dart';

import '../location/location.dart';
import '../location/permission_status.dart';

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
  final Location location = Location();

  LocationData _location;
  bool _loading = false;
  String _error;
  String qrString;

  // Method
  @override
  void initState() {
    super.initState();
    // readPromotion();
    // readNews();
    myUserModel = widget.userModel;
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
        'https://nottinhere.com/demo/stap/api/json_submit_checkin.php?lat=$lat&lng=$lng&memberID=$memberID';
    await http.get(url).then((response) {});
  }

  Image showImageNetWork(String urlImage) {
    return Image.network(urlImage);
  }

  Widget myCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget logoutBox() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.lightBlue.shade50,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 45.0,
                  child: Image.asset('images/icon_logout.png'),
                  padding: EdgeInsets.all(8.0),
                ),
                Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click logout');
          logOut();
        },
      ),
    );
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    exit(0);
  }

  Future<void> readQRcodePreview() async {
    try {
      final qrScanString = await Navigator.push(this.context,
          MaterialPageRoute(builder: (context) => ScanPreviewPage()));

      print('Before scan');
      // final qrScanString = await BarcodeScanner.scan();
      print('After scan');
      print('scanl result: $qrScanString');
      qrString = qrScanString;
      if (qrString != null) {
        decodeQRcode(qrString);
      }
      // setState(() => scanResult = qrScanString);
    } on PlatformException catch (e) {
      print('e = $e');
    }
  }

  Future<void> decodeQRcode(var code) async {
    try {
      String url =
          'http://ptnpharma.com/apishop/json_productlist.php?bqcode=$code';
      http.Response response = await http.get(url);
      var result = json.decode(response.body);
      print('result ===*******>>>> $result');

      int status = 1; //  result['status'];
      if (status == 0) {
        print('QR result > 0');
        normalDialog(context, 'Not found', 'ไม่พบ code :: $code ในระบบ');
      } else {
        print('QR result > 1');
        _getLocation();
      }
    } catch (e) {}
  }

  Widget okButton(BuildContext buildContext) {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(buildContext).pop(); // pop คือการทำให้มันหายไป
      },
    );
  }

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
                Container(
                  width: 70.0,
                  child: Image.asset('images/barcode.png'),
                ),
                Text(
                  'Scan Checkin',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          readQRcodePreview();
        },
      ),
    );
  }

  Widget btnCheckin() {
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
                Container(
                  width: 70.0,
                  child: Image.asset('images/checkin.png'),
                ),
                Text(
                  'Check in',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          _getLocation();
        },
      ),
    );
  }

  Widget LogoutBox() {
    // losesale
    return Container(
      // width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
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
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_logout.png'),
                ),
                Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click square logout');
          logOut();
        },
      ),
    );
  }

  Widget row1Menu() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        btnScanCheckin(),
        btnCheckin(),
      ],
    );
  }

  Widget mySizebox() {
    return SizedBox(
      width: 10.0,
      height: 10.0,
    );
  }

  Widget homeMenu() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      alignment: Alignment(0.0, 0.0),
      // color: Colors.green.shade50,
      // height: MediaQuery.of(context).size.height * 0.5 - 81,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          row1Menu(),
          mySizebox(),
        ],
      ),
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
          // headTitle('ข้อมูลของคุณ', Icons.verified_user),
          // profileBox(),
          headTitle('เมนู', Icons.home),
          homeMenu(),
          // Container(
          //   margin: const EdgeInsets.all(10),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.lightBlue,
          //       padding: EdgeInsets.all(8),
          //       textStyle: TextStyle(fontSize: 20),
          //     ),
          //     child: Text('Request Runtime Camera Permission'),
          //     onPressed: requestCameraPermission,
          //   ),
          // ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: const <Widget>[
                  PermissionStatusWidget(),
                  // Divider(height: 32),
                  // ServiceEnabledWidget(),
                  // Divider(height: 32),
                  // GetLocationWidget(),
                  // Divider(height: 32),
                  // ListenLocationWidget(),
                  // Divider(height: 32),
                  // ChangeSettings(),
                  // Divider(height: 32),
                  // EnableInBackgroundWidget(),
                  // Divider(height: 32),
                  // ChangeNotificationWidget()
                ],
              ),
            ),
          ),
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
