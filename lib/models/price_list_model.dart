class PriceListModel {
  String lable;
  int price;
  String unit;
  String quantity;

  PriceListModel({this.lable, this.price, this.unit, this.quantity});

  PriceListModel.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    price = json['price'];
    unit = json['unit'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lable'] = this.lable;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['quantity'] = this.quantity;
    return data;
  }
}
