class FaqResponseModel {
  FaqResponseModel({
      this.status, 
      this.responseData,});

  FaqResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? FaqResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  FaqResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class FaqResponseData {
  FaqResponseData({
      this.data,});

  FaqResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FaqData.fromJson(v));
      });
    }
  }
  List<FaqData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class FaqData {
  FaqData({
      this.id, 
      this.question, 
      this.answer,});

  FaqData.fromJson(dynamic json) {
    id = json['_id'];
    question = json['question'];
    answer = json['answer'];
  }
  String? id;
  String? question;
  String? answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['question'] = question;
    map['answer'] = answer;
    return map;
  }

}