class NewsAllModel {
  int id;
  String subject;
  String detail;
  String postdate;
  String photo;
  String document;

  NewsAllModel(
      {this.id,
      this.subject,
      this.detail,
      this.postdate,
      this.photo,
      this.document});

  NewsAllModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    detail = json['detail'];
    postdate = json['postdate'];
    photo = json['photo'];
    document = json['document'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['detail'] = this.detail;
    data['postdate'] = this.postdate;
    data['photo'] = this.photo;
    data['document'] = this.document;
    return data;
  }
}
