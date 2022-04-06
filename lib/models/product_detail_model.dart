class ProductDetailModel {
  String title;
  String productCode;
  String photo;
  Null priceList;
  String unitOrderShow;
  String sumStock;
  String cMin;
  int subtract;
  String percentStock;
  String priceOrder;
  String priceSale;
  int dealOrder;
  int freeOrder;
  int recommend;
  int promotion;
  int updateprice;
  int newproduct;
  String emotical;
  int id;

  ProductDetailModel(
      {this.title,
      this.productCode,
      this.photo,
      this.priceList,
      this.unitOrderShow,
      this.sumStock,
      this.cMin,
      this.subtract,
      this.percentStock,
      this.priceOrder,
      this.priceSale,
      this.dealOrder,
      this.freeOrder,
      this.recommend,
      this.promotion,
      this.updateprice,
      this.newproduct,
      this.emotical,
      this.id});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    productCode = json['product_code'];
    photo = json['photo'];
    priceList = json['price_list'];
    unitOrderShow = json['unit_order_show'];
    sumStock = json['sum_stock'];
    cMin = json['c_min'];
    subtract = json['subtract'];
    percentStock = json['percentStock'];
    priceOrder = json['price_order'];
    priceSale = json['price_sale'];
    dealOrder = json['deal_order'];
    freeOrder = json['free_order'];
    recommend = json['recommend'];
    promotion = json['promotion'];
    updateprice = json['updateprice'];
    newproduct = json['newproduct'];
    emotical = json['emotical'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['product_code'] = this.productCode;
    data['photo'] = this.photo;
    data['price_list'] = this.priceList;
    data['unit_order_show'] = this.unitOrderShow;
    data['sum_stock'] = this.sumStock;
    data['c_min'] = this.cMin;
    data['subtract'] = this.subtract;
    data['percentStock'] = this.percentStock;
    data['price_order'] = this.priceOrder;
    data['price_sale'] = this.priceSale;
    data['deal_order'] = this.dealOrder;
    data['free_order'] = this.freeOrder;
    data['recommend'] = this.recommend;
    data['promotion'] = this.promotion;
    data['updateprice'] = this.updateprice;
    data['newproduct'] = this.newproduct;
    data['emotical'] = this.emotical;
    data['id'] = this.id;
    return data;
  }
}
