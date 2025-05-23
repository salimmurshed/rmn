class LegalsResponseModel {
  LegalsResponseModel({
      this.status, 
      this.responseData,});

  LegalsResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? LegalsResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  LegalsResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class LegalsResponseData {
  LegalsResponseData({
      this.data,});

  LegalsResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(LegalsData.fromJson(v));
      });
    }
  }
  List<LegalsData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class LegalsData {
  LegalsData({
      this.id, 
      this.pageTitle, 
      this.pageName, 
      this.description, 
      this.version, 
      this.createdAt, 
      this.updatedAt, 
      this.pageType,});

  LegalsData.fromJson(dynamic json) {
    id = json['_id'];
    pageTitle = json['page_title'];
    pageName = json['page_name'];
    description = json['description'];
    version = json['version'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    pageType = json['page_type'];
  }
  String? id;
  String? pageTitle;
  String? pageName;
  String? description;
  num? version;
  String? createdAt;
  String? updatedAt;
  String? pageType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['page_title'] = pageTitle;
    map['page_name'] = pageName;
    map['description'] = description;
    map['version'] = version;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['page_type'] = pageType;
    return map;
  }

}