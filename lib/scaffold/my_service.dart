import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stpwcheckin/models/user_model.dart';
import 'package:stpwcheckin/scaffold/result_code.dart';
import 'package:stpwcheckin/utility/my_style.dart';
import 'package:stpwcheckin/widget/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyService extends StatefulWidget {
  final UserModel userModel;
  MyService({Key key, this.userModel}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  //Explicit
  UserModel myUserModel;
  Widget currentWidget = Home();
  String qrString;

  // Method
  @override
  void initState() {
    super.initState(); // จะทำงานก่อน build
    setState(() {
      myUserModel = widget.userModel;
      currentWidget = Home(
        userModel: myUserModel,
      );
    });
    //readCart();
  }

  Widget menuHome() {
    return ListTile(
      leading: Icon(
        Icons.home,
        size: 36.0,
      ),
      title: Text('Home'),
      subtitle: Text('Description Home'),
      onTap: () {
        setState(() {
          currentWidget = Home(
            userModel: myUserModel,
          );
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget showAppName() {
    return Text('For Driver');
  }

  Widget showLogin() {
    String login = myUserModel.subject;
    if (login == null) {
      login = '...';
    }
    return Text('Login by $login');
  }

  Widget menuLogOut() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
      ),
      title: Text('Logout and exit'),
      subtitle: Text('Logout and exit'),
      onTap: () {
        logOut();
      },
    );
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    exit(0);
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget headDrawer() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[showLogo(), showAppName(), showLogin()],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          headDrawer(),
          menuHome(),
          menuLogOut(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().barColor,
        title: Text('Home'),
      ),
      body: currentWidget,
      drawer: showDrawer(),
    );
  }
}
