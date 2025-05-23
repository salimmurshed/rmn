class TransactionFeeResponseModel {
  TransactionFeeResponseModel({
      this.status, 
      this.responseData,});

  TransactionFeeResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? TransactionFeeResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  TransactionFeeResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class TransactionFeeResponseData {
  TransactionFeeResponseData({
      this.data,});

  TransactionFeeResponseData.fromJson(dynamic json) {
    data = json['data'] != null ? TransactionFee.fromJson(json['data']) : null;
  }
  TransactionFee? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class TransactionFee {
  TransactionFee({
      this.transactionFees,});

  TransactionFee.fromJson(dynamic json) {
    transactionFees = json['transaction_fees'];
  }
  num? transactionFees;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['transaction_fees'] = transactionFees;
    return map;
  }

}