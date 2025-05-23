class SalesTransactionResponseModel {
  SalesTransactionResponseModel({
      this.status, 
      this.responseData,});

  SalesTransactionResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? SalesResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  SalesResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class SalesResponseData {
  SalesResponseData({
      this.total, 
      this.page, 
      this.perPage, 
      this.totalPage, 
      this.assetsUrl, 
      this.data, 
      this.message,});

  SalesResponseData.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    perPage = json['per_page'];
    totalPage = json['total_page'];
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SalesData.fromJson(v));
      });
    }
    message = json['message'];
  }
  num? total;
  num? page;
  num? perPage;
  num? totalPage;
  String? assetsUrl;
  List<SalesData>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['per_page'] = perPage;
    map['total_page'] = totalPage;
    map['assets_url'] = assetsUrl;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }

}

class SalesData {
  SalesData({
      this.id, 
      this.orderNo, 
      this.paymentMethod, 
      this.amount, 
      this.createdAt, 
      this.event, 
      this.purchaseType, 
      this.purchasedBy,
      this.qty,
      this.isDownloaded,
      this.cardBrand,
      this.invoiceUrl,});

  SalesData.fromJson(dynamic json) {
    id = json['_id'];
    orderNo = json['order_no'];
    paymentMethod = json['payment_method'];
    isDownloaded = json['isDownloaded'];
    amount = json['amount'];
    createdAt = json['createdAt'];
    purchasedBy = json['purchased_by'];
    event = json['event'] != null ? Event.fromJson(json['event']) : null;
    purchaseType = json['purchase_type'];
    qty = json['qty'];
    invoiceUrl = json['invoice_url'];
    cardBrand = json['card_brand'];
  }
  String? id;
  String? orderNo;
  String? paymentMethod;
  num? amount;
  String? createdAt;
  Event? event;
  String? cardBrand;
  String? purchaseType;
  String? purchasedBy;
  num? qty;
  String? invoiceUrl;
  bool? isDownloaded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['order_no'] = orderNo;
    map['card_brand'] = cardBrand;
    map['purchased_by'] = purchasedBy;
    map['payment_method'] = paymentMethod;
    map['amount'] = amount;
    map['isDownloaded'] = isDownloaded;
    map['createdAt'] = createdAt;
    if (event != null) {
      map['event'] = event?.toJson();
    }
    map['purchase_type'] = purchaseType;
    map['qty'] = qty;
    map['invoice_url'] = invoiceUrl;
    return map;
  }

}

class Event {
  Event({
      this.id, 
      this.title,});

  Event.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
  }
  String? id;
  String? title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['title'] = title;
    return map;
  }

}