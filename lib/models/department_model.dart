class DepartmentModel {
  String dpId;
  String dpName;

  DepartmentModel({this.dpId, this.dpName});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    dpId = json['dp_id'];
    dpName = json['dp_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dp_id'] = this.dpId;
    data['dp_name'] = this.dpName;
    return data;
  }
}
