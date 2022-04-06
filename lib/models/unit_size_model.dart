class UnitSizeModel {
  String lable;
  String price;
  String unit;

  UnitSizeModel({this.lable, this.price, this.unit});

  UnitSizeModel.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    price = json['price'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lable'] = this.lable;
    data['price'] = this.price;
    data['unit'] = this.unit;
    return data;
  }
}
