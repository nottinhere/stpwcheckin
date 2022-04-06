class ProductAllModel {
  String title;
  String productCode;
  String photo;
  Null priceList;
  String unitOrderShow;
  String sumStock;
  String cMin;
  int subtract;
  String percentStock;
  String pcStock;
  String overStock;
  String percentOverStock;
  String sumPriceOver;
  String sumLosesaleInStock;
  String priceOrder;
  String priceSale;
  String demand;
  int dealOrder;
  int freeOrder;
  int recommend;
  int promotion;
  int updateprice;
  int newproduct;
  int itemStatus;
  String itemStatusText;
  String itemSum;
  int orderStatus;
  String emotical;
  int id;

  ProductAllModel(
      {this.title,
      this.productCode,
      this.photo,
      this.priceList,
      this.unitOrderShow,
      this.sumStock,
      this.cMin,
      this.subtract,
      this.percentStock,
      this.pcStock,
      this.overStock,
      this.percentOverStock,
      this.sumPriceOver,
      this.sumLosesaleInStock,
      this.priceOrder,
      this.priceSale,
      this.demand,
      this.dealOrder,
      this.freeOrder,
      this.recommend,
      this.promotion,
      this.updateprice,
      this.newproduct,
      this.itemStatus,
      this.itemStatusText,
      this.itemSum,
      this.orderStatus,
      this.emotical,
      this.id});

  ProductAllModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    productCode = json['product_code'];
    photo = json['photo'];
    priceList = json['price_list'];
    unitOrderShow = json['unit_order_show'];
    sumStock = json['sum_stock'];
    cMin = json['c_min'];
    subtract = json['subtract'];
    percentStock = json['percentStock'];
    pcStock = json['pcStock'];
    overStock = json['overStock'];
    percentOverStock = json['percentOverStock'];
    sumPriceOver = json['sumPriceOver'];
    sumLosesaleInStock = json['sumLosesaleInStock'];
    priceOrder = json['price_order'];
    priceSale = json['price_sale'];
    demand = json['demand'];
    dealOrder = json['deal_order'];
    freeOrder = json['free_order'];
    recommend = json['recommend'];
    promotion = json['promotion'];
    updateprice = json['updateprice'];
    newproduct = json['newproduct'];
    itemStatus = json['itemStatus'];
    itemStatusText = json['itemStatusText'];
    itemSum = json['item_sum'];
    orderStatus = json['orderStatus'];
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
    data['pcStock'] = this.pcStock;
    data['overStock'] = this.overStock;
    data['percentOverStock'] = this.percentOverStock;
    data['sumPriceOver'] = this.sumPriceOver;
    data['sumLosesaleInStock'] = this.sumLosesaleInStock;
    data['price_order'] = this.priceOrder;
    data['price_sale'] = this.priceSale;
    data['demand'] = this.demand;
    data['deal_order'] = this.dealOrder;
    data['free_order'] = this.freeOrder;
    data['recommend'] = this.recommend;
    data['promotion'] = this.promotion;
    data['updateprice'] = this.updateprice;
    data['newproduct'] = this.newproduct;
    data['itemStatus'] = this.itemStatus;
    data['itemStatusText'] = this.itemStatusText;
    data['item_sum'] = this.itemSum;
    data['orderStatus'] = this.orderStatus;
    data['emotical'] = this.emotical;
    data['id'] = this.id;
    return data;
  }
}
