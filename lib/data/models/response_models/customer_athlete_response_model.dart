import '../../../imports/data.dart';

class CustomerAthleteResponseModel {
  bool? status;
  CustomerAthleteResponseData? responseData;

  CustomerAthleteResponseModel({this.status, this.responseData});

  CustomerAthleteResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? CustomerAthleteResponseData.fromJson(json['responseData'])
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

class CustomerAthleteResponseData {
  List<Athlete>? data;
  String? message;
  String? assetsUrl;

  CustomerAthleteResponseData({this.data, this.message, this.assetsUrl});

  CustomerAthleteResponseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Athlete>[];
      json['data'].forEach((v) {
        data!.add(Athlete.fromJson(v));
      });
    }
    message = json['message'];
    assetsUrl = json['assets_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['assets_url'] = assetsUrl;
    return data;
  }
}





