import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stpwcheckin/models/product_all_model.dart';
import 'package:stpwcheckin/models/complain_all_model.dart';
import 'package:stpwcheckin/models/staff_all_model.dart';
import 'package:stpwcheckin/models/user_model.dart';
import 'package:stpwcheckin/scaffold/detail_cart.dart';
import 'package:stpwcheckin/utility/my_style.dart';
import 'package:stpwcheckin/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stpwcheckin/widget/home.dart';

class DetailStaff extends StatefulWidget {
  final ComplainAllModel complainAllModel;
  final UserModel userModel;

  DetailStaff({Key key, this.complainAllModel, this.userModel})
      : super(key: key);

  @override
  _DetailStaffState createState() => _DetailStaffState();
}

class _DetailStaffState extends State<DetailStaff> {
  // Explicit
  ComplainAllModel currentComplainAllModel;
  ComplainAllModel complainAllModel;
  StaffModel staffAllModel;

  int amontCart = 0;
  UserModel myUserModel;
  String id; // productID

  String txtdeal = '', txtfree = '', txtprice = '', txtnote = '';
  String memberID;

  int page = 1, dp = 1;
  String searchString = '';

  List<StaffModel> staffModels = List(); // set array
  List<StaffModel> filterStaffModels = List();
  String _mySelection;

  bool isButtonCheckinActive = true;
  bool isButtonCheckoutActive = true;

  // Method
  @override
  void initState() {
    super.initState();
    currentComplainAllModel = widget.complainAllModel;
    myUserModel = widget.userModel;

    setState(() {
      getProductWhereID();
      readCart();
      readStaff();
    });
  }

  Future<void> getProductWhereID() async {
    if (currentComplainAllModel != null) {
      id = currentComplainAllModel.id.toString();
      // String url = '${MyStyle().getProductWhereId}$id';
      String url =
          'https://nottinhere.com/demo/stap/api/json_data_complaindetail.php?id=$id';
      print('url = $url');
      http.Response response = await http.get(url);
      var result = json.decode(response.body);
      print('result = $result');

      var itemProducts = result['itemsData'];
      for (var map in itemProducts) {
        setState(() {
          complainAllModel = ComplainAllModel.fromJson(map);
          Map<String, dynamic> priceListMap = map['price_list'];
          _mySelection =
              (complainAllModel.staff == '-') ? null : complainAllModel.staff;
          isButtonCheckinActive =
              (complainAllModel.startdate_fix == '-') ? true : false;
          isButtonCheckoutActive =
              (complainAllModel.enddate_fix == '-') ? true : false;
        });
      } // for

    }
  }

  List dataST;
  Future<void> readStaff() async {
    int memberId = myUserModel.id;
    String urlDV =
        'https://nottinhere.com/demo/stap/api/json_data_staff.php?memberId=$memberId&searchKey=$searchString&page=$page&dp=$dp';
    http.Response response = await http.get(urlDV);
    var result = json.decode(response.body);
    var itemDivisions = result['itemsData'];
    setState(() {
      dataST = itemDivisions;
    });
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    exit(0);
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

  Widget unreadTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.10,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.red.shade700,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'ยังไม่ตรวจสอบ',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click promotion');
          // routeToListComplain(2);
        },
      ),
    );
  }

  Widget openedTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.10,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.blue.shade600,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'ตรวจสอบแล้ว',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click update price');
          // routeToListComplain(3);
        },
      ),
    );
  }

  Widget inprocessTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.10,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.orange.shade800,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'กำลังดำเนินการ',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click new item');
          // routeToListComplain(1);
        },
      ),
    );
  }

  Widget completeTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.10,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.green.shade800,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'ดำเนินการเรียบร้อบ',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click not receive');
          // routeToListComplain(4);
        },
      ),
    );
  }

  Widget incompleteTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.10,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.grey.shade600,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'ไม่สามารถนำเนินการได้',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click not receive');
          // routeToListComplain(4);
        },
      ),
    );
  }

  Widget showTag() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 5.0,
          height: 8.0,
        ),
        (complainAllModel.status == '1') ? unreadTag() : Container(),
        (complainAllModel.status == '2') ? openedTag() : Container(),
        (complainAllModel.status == '3') ? inprocessTag() : Container(),
        (complainAllModel.status == '4') ? completeTag() : Container(),
        (complainAllModel.status == '5') ? incompleteTag() : Container(),
        SizedBox(
          width: 5.0,
          height: 8.0,
        )
      ],
    );
  }

  Widget showSubject() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.75, //0.7 - 50,
          child: Text(
            complainAllModel.subject,
            style: MyStyle().h3bStyle,
          ),
        ),
      ],
    );
  }

  Widget showResponsible() {
    String selectedDate;

    if (complainAllModel.appointdate == '-') {
      selectedDate = '-';
    } else {
      DateTime dateApt =
          DateTime.parse((complainAllModel.appointdate).toString());
      selectedDate = DateFormat('dd/MM/yyyy').format(dateApt);
      ;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            // Icon(Icons.restaurant, color: Colors.green[500]),
            Text('ผู้แจ้ง'),
            Text(
              complainAllModel.postby,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
          ],
        ),
        Column(
          children: [
            // Icon(Icons.restaurant, color: Colors.green[500]),
            Text('วันนัดหมาย'),
            Text(
              '${selectedDate}  ${complainAllModel.appointtime}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
          ],
        ),
        Column(
          children: [
            // Icon(Icons.timer, color: Colors.green[500]),
            Text('แผนกรับผิดชอบ'),
            Text(
              complainAllModel.department,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
          ],
        ),
      ],
    );
    // return Text('na');
  }

  Widget mySizebox() {
    return SizedBox(
      width: 10.0,
      height: 20.0,
    );
  }

  Widget showHeader() {
    return Card(
      child: Container(
        // width: MediaQuery.of(context).size.width * 1.00,
        padding: new EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'หมายเลขเรื่อง :${complainAllModel.id}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(0xff, 16, 149, 161),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'วันที่รับแจ้ง : ${complainAllModel.postdate} ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,

                        // color: Color.fromARGB(0xff, 16, 149, 161),
                      ),
                    ),
                  ],
                ),
                // Image.network(
                //   complainAllModel.emotical,
                //   width: MediaQuery.of(context).size.width * 0.16,
                // ),
              ],
            ),
            mySizebox(),
            Container(
              width: MediaQuery.of(context).size.width * 0.90, //0.7 - 50,
              child: Text(
                complainAllModel.subject,
                style: MyStyle().h3bStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget complainBox() {
    return Container(
      // decoration: MyStyle().boxLightGreen,
      // height: 35.0,

      width: MediaQuery.of(context).size.width * 0.63,
      padding: EdgeInsets.only(left: 10.0, right: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Column(
              children: [
                // Icon(Icons.restaurant, color: Colors.green[500]),
                Text(
                  'หัวข้อเรื่อง',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  complainAllModel.subject,
                  style: TextStyle(
                    fontSize: 16.0,
                    // fontWeight: FontWeight.bold,
                    color: Color.fromARGB(0xff, 0, 0, 0),
                  ),
                ),
              ],
            ),
            mySizebox(),
            Column(
              children: [
                // Icon(Icons.timer, color: Colors.green[500]),
                Text(
                  'รายละเอียด',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  complainAllModel.detail,
                  style: TextStyle(
                    fontSize: 16.0,
                    // fontWeight: FontWeight.bold,
                    color: Color.fromARGB(0xff, 0, 0, 0),
                  ),
                ),
              ],
            ),
            mySizebox(),
            Column(
              children: [
                // Icon(Icons.kitchen, color: Colors.green[500]),
                Text(
                  'สถานที่',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  complainAllModel.location,
                  style: TextStyle(
                    fontSize: 16.0,
                    // fontWeight: FontWeight.bold,
                    color: Color.fromARGB(0xff, 0, 0, 0),
                  ),
                ),
              ],
            ),
            mySizebox(),
            Text('ราคา :'),
            TextFormField(
              style: TextStyle(color: Colors.black),
              initialValue: complainAllModel.postby, // set default value
              keyboardType: TextInputType.number,
              onChanged: (string) {
                txtprice = string.trim();
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  top: 6.0,
                ),
                prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
                // border: InputBorder.none,
                hintText: 'ราคา',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget startdateBtn() {
    int post_id = complainAllModel.id;
    return Container(
      width: MediaQuery.of(context).size.width * 0.10,
      // height: 80.0,
      child: GestureDetector(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            onSurface: Colors.green,
          ),
          child: const Text('ลงเวลาเข้า'),
          onPressed: isButtonCheckinActive
              ? () {
                  print('You click checkin');
                  checkIn();
                  setState(() {
                    isButtonCheckinActive = false;
                    DateTime now = DateTime.now();
                    complainAllModel.startdate_fix =
                        DateFormat('dd/MM/yyyy HH:mm').format(now).toString();
                    // startdateShow();
                  });
                }
              : null,
        ),
      ),
    );
  }

  Future<void> checkIn() async {
    memberID = myUserModel.id.toString();
    var cpID = currentComplainAllModel.id;

    String url =
        'https://nottinhere.com/demo/stap/api/json_submit_checkin.php?memberId=$memberID&cpID=$cpID'; //'';

    await http.get(url).then((value) {
      // confirmSubmit();
    });
  }

  Widget startdateShow() {
    return Container(
        child: Column(children: <Widget>[
      Text(
        complainAllModel.startdate_fix,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(0xff, 0, 0, 0),
        ),
      ),
    ]));
  }

  Widget showAppointStartdate() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.33,
      child: Column(
        children: <Widget>[
          Text(
            'วันเริ่มงาน',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          startdateBtn(),
          startdateShow(),
        ],
      ),
    );
  }

  Widget enddateBtn() {
    int post_id = complainAllModel.id;
    return Container(
      width: MediaQuery.of(context).size.width * 0.10,
      // height: 80.0,
      child: GestureDetector(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            onSurface:
                (isButtonCheckinActive == true) ? Colors.black : Colors.green,
          ),
          child: const Text('ลงเวลาออก'),
          onPressed: (isButtonCheckoutActive && isButtonCheckinActive == false)
              ? () {
                  print('You click checkout');
                  checkOut();
                  setState(() {
                    isButtonCheckoutActive = false;
                    DateTime now = DateTime.now();
                    complainAllModel.enddate_fix =
                        DateFormat('dd/MM/yyyy HH:mm').format(now).toString();
                    // startdateShow();
                  });
                }
              : null,
        ),
      ),
    );
  }

  Widget enddateShow() {
    return Container(
        child: Column(children: <Widget>[
      Text(
        complainAllModel.enddate_fix,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(0xff, 0, 0, 0),
        ),
      ),
    ]));
  }

  Widget showAppointEnddate() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.33,
      child: Column(
        children: <Widget>[
          Text(
            'วันจบงาน',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          enddateBtn(),
          enddateShow(),
        ],
      ),
    );
  }

  Future<void> checkOut() async {
    //  postID = post_id;
    memberID = myUserModel.id.toString();
    var cpID = currentComplainAllModel.id;

    String url =
        'https://nottinhere.com/demo/stap/api/json_submit_checkout.php?memberId=$memberID&cpID=$cpID'; //'';

    await http.get(url).then((value) {
      // confirmSubmit();
    });
  }

  Widget showAppoint() {
    return Card(
      // width: MediaQuery.of(context).size.width * 0.33,
      child: Column(
        children: <Widget>[
          Text(
            'ผู้รับผิดชอบ',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          Text(
            complainAllModel.staff_name,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
          ),
          mySizebox(),
          showAppointStartdate(),
          mySizebox(),
          showAppointEnddate(),
          mySizebox(),
        ],
      ),
    );
  }

  // Widget noteBox() {
  //   return Container(
  //     margin: EdgeInsets.only(left: 10.0, right: 10.0),
  //     child: TextField(
  //       onChanged: (value) {
  //         txtnote = value.trim();
  //       },
  //       keyboardType: TextInputType.multiline,
  //       maxLines: 2,
  //       decoration: InputDecoration(
  //           prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
  //           labelText: 'Note :'),
  //     ),
  //   );
  // }

  Widget showFormDeal() {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[complainBox(), showAppoint()],
          ),
          // noteBox(),
          //  Row(children: <Widget>[priceBox(),priceBox(),],),
          //  Row(children: <Widget>[noteBox()],),
        ],
      ),
    );
  }

  Future<void> submitThread() async {
    try {
      var medID = currentComplainAllModel.id;
      var cpID = currentComplainAllModel.id;

      String url =
          'https://nottinhere.com/demo/stap/api/json_submit_staff.php?memberId=$memberID&cpID=$cpID&assignTo=$_mySelection&note=$txtnote'; //'';

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
            content: Text('แก้ไขดีลเรียบร้อย'),
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
              var cpID = currentComplainAllModel.id;
              print(
                  'memberId=$memberID&cpID=$cpID&assignTo=$_mySelection&note=$txtnote');

              submitThread();
            },
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget showPhoto() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5 - 50,
      child: Image.network(
        complainAllModel.postby,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget showPackage(int index) {
    return Text(complainAllModel.postby);
  }

  Widget showChoosePricePackage(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        showDetailStaffPrice(index),
        // incDecValue(index),
      ],
    );
  }

  Widget showDetailStaffPrice(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showPackage(index),
      ],
    );
  }

  Widget showPrice() {
    return Container(
      height: 150.0,
      // color: Colors.grey,
      child: ListView.builder(
        // itemCount: unitSizeModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return showChoosePricePackage(index); // showDetailStaffPrice(index);
        },
      ),
    );
  }

  Future<void> readCart() async {
    amontCart = 0;
    String memberId = myUserModel.id.toString();
    String url =
        'http://stpwcheckin.com/api/json_loadmycart.php?memberId=$memberId';

    http.Response response = await http.get(url);
    var result = json.decode(response.body);
    var cartList = result['cart'];

    for (var map in cartList) {
      setState(() {
        amontCart++;
      });
    }
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

  void routeToDetailStaffCart() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return DetailCart(
        userModel: myUserModel,
      );
    });
    Navigator.of(context).push(materialPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          // Home(),
        ],
        backgroundColor: MyStyle().barColor,
        title: Text('เรื่องร้องเรียน :: รายละเอียดงาน'),
      ),
      body: complainAllModel == null ? showProgress() : showDetailStaffList(),
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget addButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                color: Colors.lightGreen,
                child: Text(
                  'Update deal',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  String productID = id;
                  String memberID = myUserModel.id.toString();

                  int index = 0;
                  List<bool> status = List();

                  bool sumStatus = true;
                  if (status.length == 1) {
                    sumStatus = status[0];
                  } else {
                    sumStatus = status[0] && status[1];
                  }

                  if (sumStatus) {
                    normalDialog(
                        context, 'Do not choose item', 'Please choose item');
                  } else {}
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> addCart(
      String productID, String unitSize, int qTY, String memberID) async {
    String url =
        'http://stpwcheckin.com/api/json_savemycart.php?productID=$productID&unitSize=$unitSize&QTY=$qTY&memberID=$memberID';

    http.Response response = await http.get(url).then((response) {
      print('upload ok');
      readCart();
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext buildContext) {
        return DetailCart(
          userModel: myUserModel,
        );
      });
      Navigator.of(context).push(materialPageRoute);
    });
  }

  Widget showDetailStaffList() {
    return Stack(
      children: <Widget>[
        showController(),
        // addButton(),
      ],
    );
  }

  ListView showController() {
    return ListView(
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        // showTitle(),
        showTag(),
        showHeader(),
        // showSubject(),
        showResponsible(),
        showFormDeal(),
        submitButton(),
        // showPhoto(),
      ],
    );
  }
}
