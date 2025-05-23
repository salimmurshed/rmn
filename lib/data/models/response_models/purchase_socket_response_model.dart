class PurchaseSocketResponseModel {
  PurchaseSocketResponseModel({
      this.readerId, 
      this.purchase,});

  PurchaseSocketResponseModel.fromJson(dynamic json) {
    readerId = json['reader_id'];
    purchase = json['purchase'] != null ? Purchase.fromJson(json['purchase']) : null;
  }
  String? readerId;
  Purchase? purchase;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reader_id'] = readerId;
    if (purchase != null) {
      map['purchase'] = purchase?.toJson();
    }
    return map;
  }

}

class Purchase {
  Purchase({
      this.date, 
      this.paymentMethodType, 
      this.cardBrand,
      this.soldBy,
      this.amount, 
      this.invoiceUrl,});

  Purchase.fromJson(dynamic json) {
    date = json['date'];
    cardBrand = json['card_brand'];
    paymentMethodType = json['payment_method_type'];
    soldBy = json['sold_by'] != null ? SoldBy.fromJson(json['sold_by']) : null;
    amount = json['amount'];
    invoiceUrl = json['invoice_url'];
  }
  String? date;
  String? paymentMethodType;
  String? cardBrand;
  SoldBy? soldBy;
  num? amount;
  String? invoiceUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['payment_method_type'] = paymentMethodType;
    map['card_brand'] = cardBrand;
    if (soldBy != null) {
      map['sold_by'] = soldBy?.toJson();
    }
    map['amount'] = amount;
    map['invoice_url'] = invoiceUrl;
    return map;
  }

}

class SoldBy {
  SoldBy({
      this.firstName, 
      this.lastName,});

  SoldBy.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
  }
  String? firstName;
  String? lastName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    return map;
  }

}