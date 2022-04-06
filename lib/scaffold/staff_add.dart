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

class AddUser extends StatefulWidget {
  final UserModel userModel;

  AddUser({Key key, this.userModel}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  // Explicit

  StaffModel staffAllModel;
  // DepartmentModel divisionModel;

  int amontCart = 0;
  UserModel myUserModel;
  String id; // productID

  String txtuser = '', txtname = '', txtcontact = '', txtdiv = '';
  String memberID;
  String strhelperID;

  int page = 1, dp = 1;
  String searchString = '';
  String _mySelection;

  // Method
  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
    // _selectedHelper = _helpers;
    setState(() {
      readDepartment();
    });
  }

  List dataDV;
  Future<void> readDepartment() async {
    String urlDV =
        'https://nottinhere.com/demo/stap/api/json_data_department.php';
    print('urlDV >> $urlDV');

    http.Response response = await http.get(urlDV);
    var result = json.decode(response.body);
    var itemDepartments = result['itemsData'];

    setState(() {
      for (var map in itemDepartments) {
        String dpID = map['dp_id'];
        String dpName = map['dp_name'];
      } // for
    });

    setState(() {
      dataDV = itemDepartments;
    });
    print('dataDV >> $dataDV');
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    exit(0);
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
                  Text('User :'),
                  mySizebox(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      // initialValue: complainAllModel.postby, // set default value
                      onChanged: (string) {
                        txtuser = string.trim();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 6.0,
                        ),
                        prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
                        // border: InputBorder.none,
                        hintText: 'User',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  mySizebox(),
                  Text('ชื่อ - นามสกุล :'),
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
                        hintText: 'ชื่อ - นามสกุล',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('เบอร์ติดต่อ :'),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      // initialValue: complainAllModel.postby, // set default value
                      keyboardType: TextInputType.number,
                      onChanged: (string) {
                        txtcontact = string.trim();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 6.0,
                        ),
                        prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
                        // border: InputBorder.none,
                        hintText: 'เบอร์ติดต่อ',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  mySizebox(),
                  Text('แผนก :'),
                  Center(
                    child: DropdownButton(
                      value: _mySelection,
                      onChanged: (String newVal) {
                        setState(() => _mySelection = newVal);
                      },
                      items: dataDV.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['dp_name']),
                          value: item['dp_id'].toString(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitThread() async {
    try {
      String url =
          'https://nottinhere.com/demo/stap/api/json_submit_manage_staff.php?memberId=$memberID&action=add&user=$txtuser&name=$txtname&contact=$txtcontact&department=$_mySelection'; //'';
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
              memberID = myUserModel.id.toString();
              // var cpID = currentComplainAllModel.id;
              print(
                  'memberId=$memberID&action=add&user=$txtuser&name=$txtname&contact=$txtcontact&department=$_mySelection');

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

  Widget Logout() {
    return GestureDetector(
      onTap: () {
        Logout();
      },
      child: Container(
        margin: EdgeInsets.only(top: 15.0, right: 5.0),
        width: 32.0,
        height: 32.0,
        child: Stack(
          children: <Widget>[
            Image.asset('images/icon_logout_white.png'),
          ],
        ),
      ),
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
        title: Text('เพิ่มรายชื่อผู้ปฎิบัติงาน'),
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
      ],
    );
  }
}
