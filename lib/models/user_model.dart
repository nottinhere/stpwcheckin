class UserModel {
  int id;
  String code;
  String user;
  String pass;
  String subject;
  String personName;
  String personContact;
  String personLineid;
  String license;
  int department;
  int status;

  UserModel(
      {this.id,
      this.code,
      this.user,
      this.pass,
      this.subject,
      this.personName,
      this.personContact,
      this.personLineid,
      this.license,
      this.department,
      this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    user = json['user'];
    pass = json['pass'];
    subject = json['subject'];
    personName = json['person_name'];
    personContact = json['person_contact'];
    personLineid = json['person_lineid'];
    license = json['license'];
    department = json['department'];

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['user'] = this.user;
    data['pass'] = this.pass;
    data['subject'] = this.subject;
    data['person_name'] = this.personName;
    data['person_contact'] = this.personContact;
    data['person_lineid'] = this.personLineid;
    data['license'] = this.license;
    data['department'] = this.department;
    data['status'] = this.status;
    return data;
  }
}
