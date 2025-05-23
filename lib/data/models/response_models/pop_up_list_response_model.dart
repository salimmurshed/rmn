class PopUpListResponseModel {
  PopUpListResponseModel({
      this.status, 
      this.responseData,});

  PopUpListResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? PopUpResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  PopUpResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class PopUpResponseData {
  PopUpResponseData({
      this.data, 
      this.message, 
      this.assetsUrl,});

  PopUpResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PopUpData.fromJson(v));
      });
    }
    message = json['message'];
    assetsUrl = json['assets_url'];
  }
  List<PopUpData>? data;
  String? message;
  String? assetsUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    map['assets_url'] = assetsUrl;
    return map;
  }

}

class PopUpData {
  PopUpData({
      this.description, 
      this.eventId, 
      this.id, 
      this.image, 
      this.popupType, 
      this.title,});

  PopUpData.fromJson(dynamic json) {
    description = json['description'];
    eventId = json['event_id'];
    id = json['_id'];
    image = json['image'];
    popupType = json['popup_type'];
    title = json['title'];
    dontShowAgain = json['dontShowAgain'];
  }
  String? description;
  String? eventId;
  String? id;
  String? image;
  String? popupType;
  String? title;
  bool? dontShowAgain;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['event_id'] = eventId;
    map['_id'] = id;
    map['image'] = image;
    map['popup_type'] = popupType;
    map['title'] = title;
    map['dontShowAgain'] = dontShowAgain;
    return map;
  }

}