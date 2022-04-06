import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:stpwcheckin/models/staff_all_model.dart';
import 'package:stpwcheckin/models/user_model.dart';
import 'package:stpwcheckin/models/department_model.dart';
import 'package:stpwcheckin/utility/my_style.dart';
import 'package:stpwcheckin/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stpwcheckin/widget/home.dart';

class AddDept extends StatefulWidget {
  final UserModel userModel;

  AddDept({Key key, this.userModel}) : super(key: key);

  @override
  _AddDeptState createState() => _AddDeptState();
}

class _AddDeptState extends State<AddDept> {
  // Explicit

  DepartmentModel departmentAllModel;
  // DivisionModel divisionModel;

  int amontCart = 0;
  UserModel myUserModel;
  DepartmentModel myDeptModel;
  String id; // productID

  String txtname = '';
  String memberID;
  String strhelperID;

  int page = 1, dp = 1;
  String searchString = '';

  // Method
  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
    setState(() {
      readDepartment();
    });
  }

  List dataDV;
  Future<void> readDepartment() async {
    String urlDV =
        'https://nottinhere.com/demo/stap/api/json_data_division.php';
    print('urlDV >> $urlDV');

    http.Response response = await http.get(urlDV);
    var result = json.decode(response.body);
    var itemDivisions = result['itemsData'];

    setState(() {
      for (var map in itemDivisions) {
        String dvID = map['dv_id'];
        String dvName = map['dv_name'];
      } // for
    });

    setState(() {
      dataDV = itemDivisions;
    });
    print('dataDV >> $dataDV');
  }

  Widget showSubject() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.75, //0.7 - 50,
          child: Text(
            'xxxxxxxxxxxxxxx',
            style: MyStyle().h3bStyle,
          ),
        ),
      ],
    );
  }

  Widget mySizebox() {
    return SizedBox(
      width: 10.0,
      height: 20.0,
    );
  }

  Widget formBox() {
    return Card(
      child: Container(
        // decoration: MyStyle().boxLightGreen,
        width: MediaQuery.of(context).size.width * 0.63,
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Text('แผนก :'),
                  mySizebox(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      // initialValue: complainAllModel.postby, // set default value
                      onChanged: (string) {
                        txtname = string.trim();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 6.0,
                        ),
                        prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
                        // border: InputBorder.none,
                        hintText: 'แผนก',
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

  Future<void> submitThread() async {
    try {
      String url =
          'https://nottinhere.com/demo/stap/api/json_submit_manage_department.php?memberId=$memberID&action=add&name=$txtname'; //'';
      print('submitURL >> $url');
      await http.get(url).then((value) {
        confirmSubmit();
      });
    } catch (e) {}
  }

  Future<void> confirmSubmit() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Complete'),
            content: Text('แก้ไขรายชื่อเรียบร้อย'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    backProcess();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  void backProcess() {
    Navigator.of(context).pop();
  }

  Widget submitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 30.0),
          child: RaisedButton(
            color: Color.fromARGB(0xff, 13, 163, 93),
            onPressed: () {
              // var deptID = myDeptModel.dpId.toString();
              // var cpID = currentComplainAllModel.id;
              // print('deptId=$deptID&action=add&name=$txtname');

              submitThread();
            },
            child: Text(
              'เพิ่มรายชื่อ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget Home() {
    return GestureDetector(
      onTap: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext buildContext) {
          return Home();
        });
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.only(top: 15.0, right: 5.0),
        width: 32.0,
        height: 32.0,
        child: Stack(
          children: <Widget>[
            Image.asset('images/home.png'),
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
          // Home(),
        ],
        backgroundColor: MyStyle().barColorAdmin,
        title: Text('เพิ่มข้อมูลแผนก'),
      ),
      body: showController(),
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  ListView showController() {
    return ListView(
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        formBox(),
        submitButton(),
        // showPhoto(),
      ],
    );
  }
}
