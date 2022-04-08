import 'package:flutter/material.dart';

class MyStyle {
  double h1 = 24.0, h2 = 18.0;
  Color mainColor = Colors.blueGrey.shade700;
  Color textColor = Colors.blueGrey.shade500;
  Color bgColor = Colors.lightBlue.shade100;
  Color barColor = Color.fromARGB(0xff, 0x67, 0x62, 0x65); // Colors.lightBlue;
  Color barColorAdmin =
      Color.fromARGB(0xff, 0x92, 0x57, 0x46); // Colors.lightBlue;

  TextStyle h1Style = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(0xff, 0x00, 0x73, 0x26),
  );

  TextStyle h2Style = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(0xff, 0x00, 0x73, 0x26),
  );

  TextStyle h3bStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(0xff, 56, 80, 82),
  );
  TextStyle h3Style = TextStyle(
    fontSize: 16.0,
    // fontWeight: FontWeight.bold,
    color: Color.fromARGB(0xff, 0x00, 0x73, 0x26),
  );

  BoxDecoration boxLightGreen = BoxDecoration(
    borderRadius: BorderRadius.circular(12.0),
    color: Color.fromARGB(0x68, 0x00, 0xd5, 0x7f),
  );

  BoxDecoration boxLightGray = BoxDecoration(
    borderRadius: BorderRadius.circular(5.0),
    color: Colors.grey.shade200,
  );

  Widget mySizebox() {
    return SizedBox(
      width: 10.0,
      height: 16.0,
    );
  }

  String fontName = 'Sarabun';

  String readAllProduct =
      'https://nottinhere.com/demo/stap/api/json_product.php?top=100';
  String readProductWhereMode =
      'https://nottinhere.com/demo/stap/api/json_product.php?searchKey=';
  String getUserWhereUserAndPass =
      'https://nottinhere.com/demo/stpwcheckin/api/json_authen.php'; // json_login.php
  String getProductWhereId =
      'https://nottinhere.com/demo/stap/api/json_productdetail.php?id=';

  String loadMyCart =
      'https://nottinhere.com/demo/stap/api/json_loadmycart.php?memberID=';

  MyStyle();
}
