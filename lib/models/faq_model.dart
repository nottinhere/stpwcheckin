class FaqModel {
  String id;
  String question;
  String answer;
  String postdate;
  String status;
  String department;

  FaqModel(
      {this.id,
      this.question,
      this.answer,
      this.postdate,
      this.status,
      this.department});

  FaqModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    postdate = json['postdate'];
    status = json['status'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['postdate'] = this.postdate;
    data['status'] = this.status;
    data['department'] = this.department;
    return data;
  }
}
