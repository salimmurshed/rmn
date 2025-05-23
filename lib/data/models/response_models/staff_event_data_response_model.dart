import '../../../imports/data.dart';

class StaffEventDataResponseModel {
  StaffEventDataResponseModel({
    this.status,
    this.responseData,
  });

  StaffEventDataResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? StaffEventResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  StaffEventResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class StaffEventResponseData {
  StaffEventResponseData({
    this.data,
    this.message,
    this.assetsUrl,
  });

  StaffEventResponseData.fromJson(dynamic json) {
    data = json['data'] != null ? EventData.fromJson(json['data']) : null;
    message = json['message'];
    assetsUrl = json['assets_url'];
  }

  EventData? data;
  String? message;
  String? assetsUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    map['assets_url'] = assetsUrl;
    return map;
  }
}

class StaffEventData {
  StaffEventData({
    this.id,
    this.title,
    this.isRegistrationExternal,
    this.totalRegistrations,
    this.guestRegistrationPrices,
    this.divisionTypes,
    this.products,
    this.eventRegistrationLimit,
  });

  StaffEventData.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    isRegistrationExternal = json['is_registration_external'];
    totalRegistrations = json['total_registrations'];
    if (json['guest_registration_prices'] != null) {
      guestRegistrationPrices = [];
      json['guest_registration_prices'].forEach((v) {
        guestRegistrationPrices?.add(GuestRegistrationPrices.fromJson(v));
      });
    }
    if (json['division_types'] != null) {
      divisionTypes = [];
      json['division_types'].forEach((v) {
        divisionTypes?.add(DivisionTypes.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
    eventRegistrationLimit = json['event_registration_limit'];
  }

  String? id;
  String? title;
  bool? isRegistrationExternal;
  num? totalRegistrations;
  List<GuestRegistrationPrices>? guestRegistrationPrices;
  List<DivisionTypes>? divisionTypes;
  List<Products>? products;
  dynamic eventRegistrationLimit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['title'] = title;
    map['is_registration_external'] = isRegistrationExternal;
    map['total_registrations'] = totalRegistrations;
    if (guestRegistrationPrices != null) {
      map['guest_registration_prices'] =
          guestRegistrationPrices?.map((v) => v.toJson()).toList();
    }
    if (divisionTypes != null) {
      map['division_types'] = divisionTypes?.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    map['event_registration_limit'] = eventRegistrationLimit;
    return map;
  }
}
