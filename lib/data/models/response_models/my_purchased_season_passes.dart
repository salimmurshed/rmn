import '../../../imports/data.dart';

class MyPurchasedSeasonPasses {
  MyPurchasedSeasonPasses({
    this.status,
    this.responseData,
  });

  MyPurchasedSeasonPasses.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? MyPurchasedResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  MyPurchasedResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class MyPurchasedResponseData {
  MyPurchasedResponseData({
    this.assetsUrl,
    this.orderInvoiceUrl,
    this.data,
    this.message,
  });

  MyPurchasedResponseData.fromJson(dynamic json) {
    assetsUrl = json['assets_url'];
    orderInvoiceUrl = json['order_invoice_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SeasonData.fromJson(v));
      });
    }
    message = json['message'];
  }

  String? assetsUrl;
  String? orderInvoiceUrl;
  List<SeasonData>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['assets_url'] = assetsUrl;
    map['order_invoice_url'] = orderInvoiceUrl;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }
}

class SeasonData {
  SeasonData({
    this.id,
    this.memberships,
    this.season,
  });

  SeasonData.fromJson(dynamic json) {
    id = json['_id'];
    if (json['memberships'] != null) {
      memberships = [];
      json['memberships'].forEach((v) {
        memberships?.add(Memberships.fromJson(v));
      });
    }
    season = json['season'] != null ? Season.fromJson(json['season']) : null;
  }

  String? id;
  List<Memberships>? memberships;
  Season? season;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (memberships != null) {
      map['memberships'] = memberships?.map((v) => v.toJson()).toList();
    }
    if (season != null) {
      map['season'] = season?.toJson();
    }
    return map;
  }
}

class Memberships {
  Memberships({
    this.id,
    this.status,
    this.qrCode,
    this.userId,
    this.quantity,
    this.totalPrice,
    this.athleteId,
    this.productId,
    this.seasonId,
    this.purchaseDate,
    this.orderNo,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.athlete,
    this.invoiceUrl,
    this.seasonTitle,
    this.excludeEvents,
    this.maxRegistrations,
    this.remainingFreeRegistrations,
    this.isDownloading,
  });

  Memberships.fromJson(dynamic json) {
    id = json['_id'];
    status = json['status'];
    quantity = json['quantity'];
    totalPrice = json['totalPrice'];
    qrCode = json['qr_code'];
    userId = json['user_id'];
    athleteId = json['athlete_id'];
    productId = json['product_id'];
    seasonId = json['season_id'];
    purchaseDate = json['purchase_date'];
    orderNo = json['order_no'];
    price = json['price'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    seasonTitle = json['seasonTitle'];
    product =
        json['product'] != null ? PurchasedProduct.fromJson(json['product']) : null;
    athlete =
        json['athlete'] != null ? Athlete.fromJson(json['athlete']) : null;
    invoiceUrl = json['invoice_url'];
    maxRegistrations = json['max_registrations'];
    remainingFreeRegistrations = json['remaining_free_registrations'];
    isDownloading = false;
    excludeEvents = json['exclude_events'] != null ? List<String>.from(json['exclude_events']) : null;
  }

  String? id;
  num? maxRegistrations;
  num? remainingFreeRegistrations;
  List<String>? excludeEvents;
  bool? status;
  bool? isDownloading;
  String? qrCode;
  String? userId;
  String? athleteId;
  String? productId;
  String? seasonId;
  String? purchaseDate;
  String? orderNo;
  num? price;
  num? quantity;
  num? totalPrice;
  String? createdAt;
  String? updatedAt;
  PurchasedProduct? product;
  Athlete? athlete;
  String? invoiceUrl;
  String? seasonTitle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['status'] = status;
   map['isDownloading'] = false;
    map['quantity'] = quantity;
    map['exclude_events'] = excludeEvents;
    map['remaining_free_registrations'] = remainingFreeRegistrations;
    map['max_registrations'] = maxRegistrations;
    map['totalPrice'] = totalPrice;
    map['qr_code'] = qrCode;
    map['user_id'] = userId;
    map['athlete_id'] = athleteId;
    map['product_id'] = productId;
    map['season_id'] = seasonId;
    map['purchase_date'] = purchaseDate;
    map['order_no'] = orderNo;
    map['seasonTitle'] = seasonTitle;
    map['price'] = price;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    if (athlete != null) {
      map['athlete'] = athlete?.toJson();
    }
    map['invoice_url'] = invoiceUrl;
    return map;
  }
}



