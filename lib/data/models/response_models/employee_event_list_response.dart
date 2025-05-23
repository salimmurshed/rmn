import 'package:rmnevents/data/models/response_models/event_details_response_model.dart';

class EmployeeEventListResponse {
  EmployeeEventListResponse({
      this.status, 
      this.responseData,});

  EmployeeEventListResponse.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? EmployeeEventResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  EmployeeEventResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class EmployeeEventResponseData {
  EmployeeEventResponseData({
      this.assetsUrl, 
      this.data, 
      this.message,});

  EmployeeEventResponseData.fromJson(dynamic json) {
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(EventData.fromJson(v));
      });
    }
    message = json['message'];
  }
  String? assetsUrl;
  List<EventData>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['assets_url'] = assetsUrl;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }

}


class Venue {
  Venue({
      this.name, 
      this.image, 
      this.video,});

  Venue.fromJson(dynamic json) {
    name = json['name'];
    image = json['image'];
    video = json['video'];
  }
  String? name;
  String? image;
  String? video;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['image'] = image;
    map['video'] = video;
    return map;
  }

}