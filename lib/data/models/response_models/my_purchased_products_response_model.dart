import '../../../imports/data.dart';

class MyPurchasedProductsResponseModel {
  MyPurchasedProductsResponseModel({
    this.status,
    this.responseData,
  });

  MyPurchasedProductsResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? MyPurchasedProductsResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  MyPurchasedProductsResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class MyPurchasedProductsResponseData {
  MyPurchasedProductsResponseData({
    this.assetsUrl,
    this.data,
    this.message,
  });

  MyPurchasedProductsResponseData.fromJson(dynamic json) {
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PurchasedProduct.fromJson(v));
      });
    }
    message = json['message'];
  }

  String? assetsUrl;
  List<PurchasedProduct>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['assets_url'] = assetsUrl;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }
}

class PurchasedProduct {
  PurchasedProduct({
    this.id,
    this.slug,
    this.coverImage,
    this.mainImage,
    this.image,
    this.title,
    this.totalAmount,
    this.totalCount,
    this.purchaseDatetime,
    this.description,
    this.isGiveaway,
    this.price,
    this.seasonId,
    this.content,
    this.qrCodeStatus,
  });

  PurchasedProduct.fromJson(dynamic json) {
    id = json['_id'];
    slug = json['slug'];
    image = json['image'];
    qrCodeStatus = json['qrCodeStatus'];
    coverImage = json['cover_image'];
    mainImage = json['main_image'];
    title = json['title'];
    totalAmount = json['total_amount'];
    totalCount = json['total_count'];
    purchaseDatetime = json['purchase_datetime'];
    description = json['description'];
    isGiveaway = json['is_giveaway'];
    price = json['price'];
    seasonId = json['season_id'];
    restrictions = json['restrictions'] != null
        ? Restrictions.fromJson(json['restrictions'])
        : null;
    content = json['content'] != null ? json['content'].cast<String>() : [];
  }

  String? id;
  String? slug;
  String? image;
  String? coverImage;
  String? mainImage;
  String? title;
  num? totalAmount;
  num? totalCount;
  String? purchaseDatetime;
  String? description;
  bool? isGiveaway;
  num? price;
  String? seasonId;
  String? qrCodeStatus;
  List<String>? content;
  Restrictions? restrictions;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['slug'] = slug;
    map['image'] = image;
    map['qrCodeStatus'] = qrCodeStatus;
    map['cover_image'] = coverImage;
    map['main_image'] = mainImage;
    map['title'] = title;
    map['total_amount'] = totalAmount;
    map['total_count'] = totalCount;
    map['purchase_datetime'] = purchaseDatetime;
    map['description'] = description;
    map['is_giveaway'] = isGiveaway;
    map['price'] = price;
    map['season_id'] = seasonId;
    map['content'] = content;
    if (restrictions != null) {
      map['restrictions'] = restrictions!.toJson();
    }
    return map;
  }
}
