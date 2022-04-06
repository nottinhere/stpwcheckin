class ProductReportModel {
  int id;
  String code;
  String name;
  String approveValue;
  String rejectValue;
  String waitValue;
  String unit;
  String subtract;

  ProductReportModel(
      {this.id,
      this.code,
      this.name,
      this.approveValue,
      this.rejectValue,
      this.waitValue,
      this.unit,
      this.subtract});

  ProductReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    approveValue = json['approve_value'];
    rejectValue = json['reject_value'];
    waitValue = json['wait_value'];
    unit = json['unit'];
    subtract = json['subtract'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['approve_value'] = this.approveValue;
    data['reject_value'] = this.rejectValue;
    data['wait_value'] = this.waitValue;
    data['unit'] = this.unit;
    data['subtract'] = this.subtract;
    return data;
  }
}
