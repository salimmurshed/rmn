class CouponDetailResponseModel {
  CouponDetailResponseModel({
      this.status, 
      this.responseData,});

  CouponDetailResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? ResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  ResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class ResponseData {
  ResponseData({
      this.message, 
      this.coupon,});

  ResponseData.fromJson(dynamic json) {
    message = json['message'];
    coupon = json['coupon'] != null ? Coupon.fromJson(json['coupon']) : null;
  }
  String? message;
  Coupon? coupon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (coupon != null) {
      map['coupon'] = coupon?.toJson();
    }
    return map;
  }

}

class Coupon {
  Coupon({
      this.code, 
      this.amount, 
      this.type, 
      this.availableFor,});

  Coupon.fromJson(dynamic json) {
    code = json['code'];
    amount = json['amount'];
    type = json['type'];
    availableFor = json['available_for'] != null ? json['available_for'].cast<String>() : [];
  }
  String? code;
  num? amount;
  String? type;
  List<String>? availableFor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['amount'] = amount;
    map['type'] = type;
    map['available_for'] = availableFor;
    return map;
  }

}