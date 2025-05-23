class PurchaseResponseModel {
  PurchaseResponseModel({
      this.status, 
      this.responseData,});

  PurchaseResponseModel.fromJson(dynamic json) {
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
      this.payment,});

  ResponseData.fromJson(dynamic json) {
    message = json['message'];
    payment = json['payment'] != null ? Payment.fromJson(json['payment']) : null;
  }
  String? message;
  Payment? payment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (payment != null) {
      map['payment'] = payment?.toJson();
    }
    return map;
  }

}

class Payment {
  Payment({
      this.user, 
      this.eventId, 
      this.refundAmount, 
      this.orderNo, 
      this.memberships, 
      this.orders, 
      this.registrations, 
      this.appliedCoupon, 
      this.receiptUrl, 
      this.id, 
      this.userId, 
      this.transactionId, 
      this.paymentMethod, 
      this.amount, 
      this.status, 
      this.transactionFee, 
      this.refundHistory, 
      this.createdAt, 
      this.updatedAt,});

  Payment.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    eventId = json['event_id'];
    refundAmount = json['refund_amount'];
    orderNo = json['order_no'];
    // if (json['memberships'] != null) {
    //   memberships = [];
    //   json['memberships'].forEach((v) {
    //     memberships?.add(Dynamic.fromJson(v));
    //   });
    // }
    // if (json['orders'] != null) {
    //   orders = [];
    //   json['orders'].forEach((v) {
    //     orders?.add(Dynamic.fromJson(v));
    //   });
    // }
    // if (json['registrations'] != null) {
    //   registrations = [];
    //   json['registrations'].forEach((v) {
    //     registrations?.add(Dynamic.fromJson(v));
    //   });
    // }
    appliedCoupon = json['applied_coupon'];
    receiptUrl = json['receipt_url'];
    id = json['_id'];
    userId = json['user_id'];
    transactionId = json['transaction_id'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    status = json['status'];
    transactionFee = json['transaction_fee'];
    // if (json['refund_history'] != null) {
    //   refundHistory = [];
    //   json['refund_history'].forEach((v) {
    //     refundHistory?.add(Dynamic.fromJson(v));
    //   });
    // }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  User? user;
  dynamic eventId;
  num? refundAmount;
  String? orderNo;
  List<dynamic>? memberships;
  List<dynamic>? orders;
  List<dynamic>? registrations;
  dynamic appliedCoupon;
  String? receiptUrl;
  String? id;
  String? userId;
  String? transactionId;
  String? paymentMethod;
  num? amount;
  String? status;
  num? transactionFee;
  List<dynamic>? refundHistory;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['event_id'] = eventId;
    map['refund_amount'] = refundAmount;
    map['order_no'] = orderNo;
    if (memberships != null) {
      map['memberships'] = memberships?.map((v) => v.toJson()).toList();
    }
    if (orders != null) {
      map['orders'] = orders?.map((v) => v.toJson()).toList();
    }
    if (registrations != null) {
      map['registrations'] = registrations?.map((v) => v.toJson()).toList();
    }
    map['applied_coupon'] = appliedCoupon;
    map['receipt_url'] = receiptUrl;
    map['_id'] = id;
    map['user_id'] = userId;
    map['transaction_id'] = transactionId;
    map['payment_method'] = paymentMethod;
    map['amount'] = amount;
    map['status'] = status;
    map['transaction_fee'] = transactionFee;
    if (refundHistory != null) {
      map['refund_history'] = refundHistory?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}

class User {
  User({
      this.mailingAddress, 
      this.zipcode, 
      this.phoneNumber, 
      this.fullName, 
      this.email,});

  User.fromJson(dynamic json) {
    mailingAddress = json['mailing_address'];
    zipcode = json['zipcode'];
    phoneNumber = json['phone_number'];
    fullName = json['full_name'];
    email = json['email'];
  }
  String? mailingAddress;
  String? zipcode;
  String? phoneNumber;
  String? fullName;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mailing_address'] = mailingAddress;
    map['zipcode'] = zipcode;
    map['phone_number'] = phoneNumber;
    map['full_name'] = fullName;
    map['email'] = email;
    return map;
  }

}