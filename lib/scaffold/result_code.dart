import 'package:flutter/material.dart';

class ResultCode extends StatefulWidget {

  final String result ;
  ResultCode({Key key,this.result}):super(key:key);


  @override
  _ResultCodeState createState() => _ResultCodeState();
}

class _ResultCodeState extends State<ResultCode> {

  // Explicit
  String resultString;

  // Method
  @override
  void initState() {
    super.initState();
    resultString = widget.result;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Code'),
      ),
      body: Center(
        child: Text('$resultString'),
      ),
    );
  }
}
