class StripeReadersResponseModel {
  StripeReadersResponseModel({
    this.status,
    this.responseData,
  });

  StripeReadersResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? StripeReadersResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  StripeReadersResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class StripeReadersResponseData {
  StripeReadersResponseData({
    this.data,
  });

  StripeReadersResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(StripeReaderData.fromJson(v));
      });
    }
  }

  List<StripeReaderData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class StripeReaderData {
  StripeReaderData({
    this.id,
    this.label,
    this.status,
    this.isAvailable,
    this.isConnectActive,
    this.isDisconnectActive,
  });

  StripeReaderData.fromJson(dynamic json) {
    id = json['id'];
    label = json['label'];
    status = json['status'];
    isAvailable = json['is_available'];
    isConnectActive = json['isConnectActive'];
    isDisconnectActive = json['isDisconnectActive'];
  }

  String? id;
  String? label;
  String? status;
  bool? isAvailable;
  bool? isConnectActive;
  bool? isDisconnectActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['label'] = label;
    map['status'] = status;
    map['is_available'] = isAvailable;
    map['isConnectActive'] = isConnectActive;
    map['isDisconnectActive'] = isDisconnectActive;
    return map;
  }
}
