class GradeResponseModel {
  GradeResponseModel({
      this.status, 
      this.responseData,});

  GradeResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? GradeResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  GradeResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class GradeResponseData {
  GradeResponseData({
      this.message, 
      this.data,});

  GradeResponseData.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GradeData.fromJson(v));
      });
    }
  }
  String? message;
  List<GradeData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class GradeData {
  GradeData({
      this.name, 
      this.value,});

  GradeData.fromJson(dynamic json) {
    name = json['name'];
    value = json['value'];
  }
  String? name;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['value'] = value;
    return map;
  }

}