
class AvailableWeightClassResponseModel {
  AvailableWeightClassResponseModel({
      this.status, 
      this.responseData,});

  AvailableWeightClassResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? AvailableWeightClassResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  AvailableWeightClassResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class AvailableWeightClassResponseData {
  AvailableWeightClassResponseData({
      this.data,});

  AvailableWeightClassResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(WeightClass.fromJson(v));
      });
    }
  }
  List<WeightClass>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class WeightClass {
  WeightClass({
      this.weight, 
      this.alias, 
      this.status, 
      this.id, 
      this.createdAt, 
      this.updatedAt,
      this.totalRegistration,
      this.maxRegistration,
      this.isCalculated
  });

  WeightClass.fromJson(dynamic json) {
    weight = json['weight'];
    alias = json['alias'] != null ? json['alias'].cast<String>() : [];
    status = json['status'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    totalRegistration = json['total_registrations'];
    maxRegistration = json['max_registrations'];
  }
  String? weight;
  List<String>? alias;
  bool? status;
  String? id;
  String? createdAt;
  String? updatedAt;
  num? maxRegistration;
  num? totalRegistration;
  bool? isSelected;
  bool? isCalculated;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['weight'] = weight;
    map['alias'] = alias;
    map['status'] = status;
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['max_registrations'] = maxRegistration;
    map['total_registrations'] = totalRegistration;
    return map;
  }

}