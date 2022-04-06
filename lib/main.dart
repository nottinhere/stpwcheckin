import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stpwcheckin/scaffold/authen.dart';

void main() {
  runApp(MyApp());
} //

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authen(),
    );
  }
}
