class ProductInCartModel {
  String title;
  String productCode;
  String photo;
  PriceList priceList;
  String detail;
  String id;

  ProductInCartModel(
      {this.title,
      this.productCode,
      this.photo,
      this.priceList,
      this.detail,
      this.id});

  ProductInCartModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    productCode = json['product_code'];
    photo = json['photo'];
    priceList = json['price_list'] != null
        ? new PriceList.fromJson(json['price_list'])
        : null;
    detail = json['detail'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['product_code'] = this.productCode;
    data['photo'] = this.photo;
    if (this.priceList != null) {
      data['price_list'] = this.priceList.toJson();
    }
    data['detail'] = this.detail;
    data['id'] = this.id;
    return data;
  }
}

class PriceList {
  S s;

  PriceList({this.s});

  PriceList.fromJson(Map<String, dynamic> json) {
    s = json['s'] != null ? new S.fromJson(json['s']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.s != null) {
      data['s'] = this.s.toJson();
    }
    return data;
  }
}

class S {
  String lable;
  String price;
  String unit;
  int quantity;

  S({this.lable, this.price, this.unit, this.quantity});

  S.fromJson(Map<String, dynamic> json) {
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
