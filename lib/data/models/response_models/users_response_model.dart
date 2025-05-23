import '../../../imports/data.dart';

class UsersResponse {
  bool? status;
  ResponseData? responseData;

  UsersResponse({this.status, this.responseData});

  UsersResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (responseData != null) {
      data['responseData'] = responseData!.toJson();
    }
    return data;
  }
}

class ResponseData {
  num? total;
  num? totalPage;
  num? page;
  num? perPage;
  String? assetsUrl;
  List<DataBaseUser>? data;

  ResponseData(
      {this.total, this.page, this.perPage, this.totalPage, this.assetsUrl, this.data});

  ResponseData.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    perPage = json['per_page'];
    totalPage = json['total_page'];
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = <DataBaseUser>[];
      json['data'].forEach((v) {
        data!.add(DataBaseUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['page'] = page;
    data['per_page'] = perPage;
    data['total_page'] = totalPage;
    data['assets_url'] = assetsUrl;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

