import '../../../imports/data.dart';

class AllEventsResponseModel {
  AllEventsResponseModel({
      this.status, 
      this.responseData,});

  AllEventsResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? AllEventsResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  AllEventsResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class AllEventsResponseData {
  AllEventsResponseData({
      this.total, 
      this.page, 
      this.perPage, 
      this.totalPage, 
      this.assetsUrl, 
      this.data, 
      this.message,});

  AllEventsResponseData.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    perPage = json['per_page'];
    totalPage = json['total_page'];
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(EventData.fromJson(v));
      });
    }
    message = json['message'];
  }
  num? total;
  num? page;
  num? perPage;
  num? totalPage;
  String? assetsUrl;
  List<EventData>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['per_page'] = perPage;
    map['total_page'] = totalPage;
    map['assets_url'] = assetsUrl;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }

}





class Links {
  Links({
      this.chat, 
      this.details,});

  Links.fromJson(dynamic json) {
    chat = json['chat'];
    details = json['details'];
  }
  String? chat;
  String? details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['chat'] = chat;
    map['details'] = details;
    return map;
  }

}

