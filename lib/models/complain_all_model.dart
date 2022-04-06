class ComplainAllModel {
  String subject;
  String detail;
  String location;
  String appointdate;
  String appointtime;
  String postdate;
  String postby;
  String status;
  String textstatus;
  String department;
  String staff;
  String staff_name;
  String helper;
  String startdate_fix;
  String enddate_fix;
  int id;

  ComplainAllModel(
      {this.subject,
      this.detail,
      this.location,
      this.appointdate,
      this.appointtime,
      this.postdate,
      this.postby,
      this.status,
      this.textstatus,
      this.department,
      this.staff,
      this.staff_name,
      this.helper,
      this.startdate_fix,
      this.enddate_fix,
      this.id});

  ComplainAllModel.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    detail = json['detail'];
    location = json['location'];
    appointdate = json['appointdate'];
    appointtime = json['appointtime'];
    postdate = json['postdate'];
    postby = json['postby'];
    status = json['status'];
    textstatus = json['textstatus'];
    department = json['department'];
    staff = json['staff'];
    staff_name = json['staff_name'];
    helper = json['helper'];
    startdate_fix = json['startdate_fix'];
    enddate_fix = json['enddate_fix'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['detail'] = this.detail;
    data['location'] = this.location;
    data['appointdate'] = this.appointdate;
    data['appointtime'] = this.appointtime;
    data['postdate'] = this.postdate;
    data['postby'] = this.postby;
    data['status'] = this.status;
    data['textstatus'] = this.textstatus;
    data['department'] = this.department;
    data['staff'] = this.staff;
    data['staff_name'] = this.staff_name;
    data['helper'] = this.helper;
    data['startdate_fix'] = this.startdate_fix;
    data['enddate_fix'] = this.enddate_fix;
    data['id'] = this.id;
    return data;
  }
}
