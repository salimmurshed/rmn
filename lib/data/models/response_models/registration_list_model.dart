class RegistrationListResponseModel {
  RegistrationListResponseModel({
    this.status,
    this.responseData,});

  RegistrationListResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? RegListResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  RegListResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class RegListResponseData {
  RegListResponseData({
    this.message,
    this.data,});

  RegListResponseData.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(RegistrationListData.fromJson(v));
      });
    }
  }
  String? message;
  List<RegistrationListData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class RegistrationListData {
  RegistrationListData({
    this.firstName,
    this.lastName,
    this.team,
    this.state,
    this.style,
    this.division,
    this.weightClass,});

  RegistrationListData.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    team = json['team'];
    state = json['state'];
    style = json['style'];
    division = json['division'];
    weightClass = json['weight_class'];
  }
  String? firstName;
  String? lastName;
  String? team;
  String? state;
  String? style;
  String? division;
  String? weightClass;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['team'] = team;
    map['state'] = state;
    map['style'] = style;
    map['division'] = division;
    map['weight_class'] = weightClass;
    return map;
  }

}