import '../../../imports/data.dart';

class StripePaymentCardResponseModel {
  StripePaymentCardResponseModel({
    this.id,
    this.object,
    this.card,
    this.clientIp,
    this.created,
    this.livemode,
    this.type,
    this.used,
    this.stripeErrorResponse,
  });

  StripePaymentCardResponseModel.fromJson(dynamic json) {
    id = json['id'];
    object = json['object'];
    card = json['card'] != null ? CardData.fromJson(json['card']) : null;
    stripeErrorResponse = json['response'] != null ? StripeErrorResponse.fromJson(json['card']) : null;
    clientIp = json['client_ip'];
    created = json['created'];
    livemode = json['livemode'];
    type = json['type'];
    used = json['used'];
  }

  String? id;
  String? object;
  CardData? card;
  String? clientIp;
  num? created;
  bool? livemode;
  String? type;
  bool? used;
  StripeErrorResponse? stripeErrorResponse;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['object'] = object;
    if (card != null) {
      map['card'] = card?.toJson();
    }
    if (stripeErrorResponse != null) {
      map['response'] = stripeErrorResponse?.toJson();
    }
    map['client_ip'] = clientIp;
    map['created'] = created;
    map['livemode'] = livemode;
    map['type'] = type;
    map['used'] = used;
    return map;
  }
}

class StripeErrorResponse {
  StripeErrorResponse({
    this.error,
  });

  StripeErrorResponse.fromJson(dynamic json) {
    error = json['error'] != null ? StripeError.fromJson(json['error']) : null;
  }

  StripeError? error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (error != null) {
      map['error'] = error?.toJson();
    }
    return map;
  }
}

class StripeError {
  StripeError({
    this.code,
    this.docUrl,
    this.message,
    this.param,
    this.requestLogUrl,
    this.type,
  });

  StripeError.fromJson(dynamic json) {
    code = json['code'];
    docUrl = json['doc_url'];
    message = json['message'];
    param = json['param'];
    requestLogUrl = json['request_log_url'];
    type = json['type'];
  }

  String? code;
  String? docUrl;
  String? message;
  String? param;
  String? requestLogUrl;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['doc_url'] = docUrl;
    map['message'] = message;
    map['param'] = param;
    map['request_log_url'] = requestLogUrl;
    map['type'] = type;
    return map;
  }
}
