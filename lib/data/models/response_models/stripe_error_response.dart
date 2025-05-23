class StripeErrorResponse {
  StripeErrorResponse({
      this.error,});

  StripeErrorResponse.fromJson(dynamic json) {
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
  Error? error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (error != null) {
      map['error'] = error?.toJson();
    }
    return map;
  }

}

class Error {
  Error({
      this.code, 
      this.docUrl, 
      this.message, 
      this.param, 
      this.requestLogUrl, 
      this.type,});

  Error.fromJson(dynamic json) {
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