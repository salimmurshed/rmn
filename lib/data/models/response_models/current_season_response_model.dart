class CurrentSeasonResponseModel {
  CurrentSeasonResponseModel({
      this.status, 
      this.responseData,});

  CurrentSeasonResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? CurrentSeasonResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  CurrentSeasonResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class CurrentSeasonResponseData {
  CurrentSeasonResponseData({
      this.data,});

  CurrentSeasonResponseData.fromJson(dynamic json) {
    data = json['data'] != null ? CurrentSeasonData.fromJson(json['data']) : null;
  }
  CurrentSeasonData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class CurrentSeasonData {
  CurrentSeasonData({
      this.id, 
      this.createdAt, 
      this.endDate, 
      this.startDate, 
      this.title, 
      this.updatedAt, 
      this.isCurrent, 
      this.underscoreId,});

  CurrentSeasonData.fromJson(dynamic json) {
    underscoreId = json['_id'];
    createdAt = json['createdAt'];
    endDate = json['end_date'];
    startDate = json['start_date'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    isCurrent = json['is_current'];
    id = json['id'];
  }
  String? id;
  String? createdAt;
  String? endDate;
  String? startDate;
  String? title;
  String? updatedAt;
  bool? isCurrent;
  String? underscoreId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = underscoreId;
    map['createdAt'] = createdAt;
    map['end_date'] = endDate;
    map['start_date'] = startDate;
    map['title'] = title;
    map['updatedAt'] = updatedAt;
    map['is_current'] = isCurrent;
    map['id'] = id;
    return map;
  }

}