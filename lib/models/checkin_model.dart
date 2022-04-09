class CheckinModel {
  String id;
  String staff;
  String thisdate;
  int sqindate;

  CheckinModel({this.id, this.staff, this.thisdate, this.sqindate});

  CheckinModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staff = json['staff'];
    thisdate = json['thisdate'];
    sqindate = json['sqindate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['staff'] = this.staff;
    data['thisdate'] = this.thisdate;
    data['sqindate'] = this.sqindate;
    return data;
  }
}
