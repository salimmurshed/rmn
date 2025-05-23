class UploadedCardListResponseModel {
  UploadedCardListResponseModel({
      this.status, 
      this.responseData,});

  UploadedCardListResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? UploadedCardListResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  UploadedCardListResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class UploadedCardListResponseData {
  UploadedCardListResponseData({
      this.data, 
      this.message,});

  UploadedCardListResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CardData.fromJson(v));
      });
    }
    message = json['message'];
  }
  List<CardData>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }

}

class CardData {
  CardData({
      this.id, 
      this.expMonthYear,
      this.object,
      this.addressCity, 
      this.addressCountry, 
      this.addressLine1, 
      this.addressLine1Check, 
      this.addressLine2, 
      this.addressState, 
      this.addressZip, 
      this.addressZipCheck, 
      this.brand, 
      this.country, 
      this.customer, 
      this.cvcCheck, 
      this.dynamicLast4, 
      this.expMonth, 
      this.expYear, 
      this.fingerprint, 
      this.funding, 
      this.last4, 
      this.metadata, 
      this.name, 
      this.isSaved,
      this.isExisting,
      this.tokenizationMethod,
      this.wallet,});

  CardData.fromJson(dynamic json) {
    id = json['id'];
    object = json['object'];
    addressCity = json['address_city'];
    addressCountry = json['address_country'];
    addressLine1 = json['address_line1'];
    addressLine1Check = json['address_line1_check'];
    addressLine2 = json['address_line2'];
    addressState = json['address_state'];
    addressZip = json['address_zip'];
    addressZipCheck = json['address_zip_check'];
    brand = json['brand'];
    country = json['country'];
    customer = json['customer'];
    cvcCheck = json['cvc_check'];
    dynamicLast4 = json['dynamic_last4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    funding = json['funding'];
    last4 = json['last4'];
    expMonthYear = json['expMonthYear'];
    metadata = json['metadata'];
    name = json['name'];
    tokenizationMethod = json['tokenization_method'];
    wallet = json['wallet'];
    isSaved = json['is_save'];
    isExisting = json['isExisting'];
  }
  String? id;
  String? object;
  dynamic addressCity;
  dynamic addressCountry;
  dynamic addressLine1;
  dynamic addressLine1Check;
  dynamic addressLine2;
  dynamic addressState;
  dynamic addressZip;
  dynamic addressZipCheck;
  String? brand;
  String? country;
  String? customer;
  String? cvcCheck;
  dynamic dynamicLast4;
  num? expMonth;
  num? expYear;
  String? expMonthYear;
  String? fingerprint;
  String? funding;
  String? last4;
  dynamic metadata;
  String? name;
  dynamic tokenizationMethod;
  dynamic wallet;

  bool? isSaved;
  bool? isExisting;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['object'] = object;
    map['is_save'] = isSaved;
    map['isExisting'] = isExisting;
    map['expMonthYear'] = expMonthYear;
    map['address_city'] = addressCity;
    map['address_country'] = addressCountry;
    map['address_line1'] = addressLine1;
    map['address_line1_check'] = addressLine1Check;
    map['address_line2'] = addressLine2;
    map['address_state'] = addressState;
    map['address_zip'] = addressZip;
    map['address_zip_check'] = addressZipCheck;
    map['brand'] = brand;
    map['country'] = country;
    map['customer'] = customer;
    map['cvc_check'] = cvcCheck;
    map['dynamic_last4'] = dynamicLast4;
    map['exp_month'] = expMonth;
    map['exp_year'] = expYear;
    map['fingerprint'] = fingerprint;
    map['funding'] = funding;
    map['last4'] = last4;
    map['metadata'] = metadata;
    map['name'] = name;
    map['tokenization_method'] = tokenizationMethod;
    map['wallet'] = wallet;
    return map;
  }

}