import 'package:rmnevents/data/models/response_models/athlete_response_model.dart';

class AllAthletesResponseModel {
  AllAthletesResponseModel({
      this.status, 
      this.responseData,});

  AllAthletesResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? AllAthletesResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  AllAthletesResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class AllAthletesResponseData {
  AllAthletesResponseData({
      this.total, 
      this.page, 
      this.perPage, 
      this.totalPage, 
      this.assetsUrl, 
      this.data,});

  AllAthletesResponseData.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    perPage = json['per_page'];
    totalPage = json['total_page'];
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Athlete.fromJson(v));
      });
    }
  }
  num? total;
  num? page;
  num? perPage;
  num? totalPage;
  String? assetsUrl;
  List<Athlete>? data;

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
    return map;
  }

}

