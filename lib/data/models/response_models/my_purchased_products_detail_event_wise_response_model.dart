import '../../../imports/data.dart';

class MyPurchasedProductsDetailEventWiseResponseModel {
  MyPurchasedProductsDetailEventWiseResponseModel({
    this.status,
    this.responseData,
  });

  MyPurchasedProductsDetailEventWiseResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? MyPurchasedProductsDetailEventWiseResponseData.fromJson(
            json['responseData'])
        : null;
  }

  bool? status;
  MyPurchasedProductsDetailEventWiseResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}
class MyPurchasedProductsDetailEventWiseResponseData {
  MyPurchasedProductsDetailEventWiseResponseData({
    this.assetsUrl,
    this.data,
    this.message,
  });

  MyPurchasedProductsDetailEventWiseResponseData.fromJson(dynamic json) {
    assetsUrl = json['assets_url'];
    data = json['data'] != null
        ? PurchasedProductData.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  String? assetsUrl;
  PurchasedProductData? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['assets_url'] = assetsUrl;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    return map;
  }
}

class PurchasedProductData {
  PurchasedProductData({
    this.id,
    this.coverImage,
    this.mainImage,
    this.timezone,
    this.isRegistrationAvailable,
    this.address,
    this.startDatetime,
    this.title,
    this.productPurchases,
    this.eventRegistrations,
    this.totalAmount,
    this.totalCount,
    this.productPurchaseDate,
    this.registrationPurchaseDate,
    this.purchaseDatetime,
    this.productInvoiceUrl,
    this.registrationInvoiceUrl,
  });

  PurchasedProductData.fromJson(dynamic json) {
    id = json['_id'];
    coverImage = json['cover_image'];
    mainImage = json['main_image'];
    timezone = json['timezone'];
    isRegistrationAvailable = json['is_registration_available'];
    address = json['address'];
    startDatetime = json['start_datetime'];
    title = json['title'];
    if (json['product_purchases'] != null) {
      productPurchases = [];
      json['product_purchases'].forEach((v) {
        productPurchases?.add(ProductPurchases.fromJson(v));
      });
    }
    if (json['event_registrations'] != null) {
      eventRegistrations = [];
      json['event_registrations'].forEach((v) {
        eventRegistrations?.add(EventRegistrations.fromJson(v));
      });
    }
    totalAmount = json['total_amount'];
    totalCount = json['total_count'];
    productPurchaseDate = json['product_purchase_date'];
    registrationPurchaseDate = json['registration_purchase_date'];
    purchaseDatetime = json['purchase_datetime'];
    productInvoiceUrl = json['product_invoice_url'];
    registrationInvoiceUrl = json['registration_invoice_url'];
  }

  String? id;
  String? coverImage;
  String? mainImage;
  String? timezone;
  bool? isRegistrationAvailable;
  String? address;
  String? startDatetime;
  String? title;
  List<ProductPurchases>? productPurchases;
  List<EventRegistrations>? eventRegistrations;
  num? totalAmount;
  num? totalCount;
  String? productPurchaseDate;
  String? registrationPurchaseDate;
  String? purchaseDatetime;
  String? productInvoiceUrl;
  String? registrationInvoiceUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['cover_image'] = coverImage;
    map['main_image'] = mainImage;
    map['timezone'] = timezone;
    map['is_registration_available'] = isRegistrationAvailable;
    map['address'] = address;
    map['start_datetime'] = startDatetime;
    map['title'] = title;
    if (productPurchases != null) {
      map['product_purchases'] =
          productPurchases?.map((v) => v.toJson()).toList();
    }
    if (eventRegistrations != null) {
      map['event_registrations'] =
          eventRegistrations?.map((v) => v.toJson()).toList();
    }
    map['total_amount'] = totalAmount;
    map['total_count'] = totalCount;
    map['product_purchase_date'] = productPurchaseDate;
    map['registration_purchase_date'] = registrationPurchaseDate;
    map['purchase_datetime'] = purchaseDatetime;
    map['product_invoice_url'] = productInvoiceUrl;
    map['registration_invoice_url'] = registrationInvoiceUrl;
    return map;
  }
}

class EventRegistrations {
  EventRegistrations({
    this.id,
    this.registrations,
    this.teamId,
    this.registrationPrice,
    this.totalRegistrations,
    this.purchaseDatetime,
    this.athlete,
    this.isAllScanned,
    this.registrationWithDivisionIdList,
    this.team,
  });

  EventRegistrations.fromJson(dynamic json) {
    id = json['_id'];
    isAllScanned = json['isAllScanned'];
    if (json['registrations'] != null) {
      registrations = [];
      json['registrations'].forEach((v) {
        registrations?.add(Registrations.fromJson(v));
      });
    }
    teamId = json['team_id'];
    registrationPrice = json['registration_price'];
    totalRegistrations = json['total_registrations'];
    purchaseDatetime = json['purchase_datetime'];
    athlete =
        json['athlete'] != null ? Athlete.fromJson(json['athlete']) : null;
    if (json['registrationWithDivisionId'] != null) {
      registrationWithDivisionIdList = [];
      json['registrationWithDivisionId'].forEach((v) {
        registrationWithDivisionIdList
            ?.add(RegistrationWithSameDivisionId.fromJson(v));
      });
    }
    team = json['team'] != null ? Team.fromJson(json['team']) : null;
  }

  String? id;
  List<Registrations>? registrations;
  String? teamId;
  num? registrationPrice;
  num? totalRegistrations;
  String? purchaseDatetime;
  Athlete? athlete;
  Team? team;
  bool? isAllScanned;
  List<RegistrationWithSameDivisionId>? registrationWithDivisionIdList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['isAllScanned'] = isAllScanned;
    if (registrations != null) {
      map['registrations'] = registrations?.map((v) => v.toJson()).toList();
    }
    map['team_id'] = teamId;
    map['registration_price'] = registrationPrice;
    map['total_registrations'] = totalRegistrations;
    map['purchase_datetime'] = purchaseDatetime;
    if (athlete != null) {
      map['athlete'] = athlete?.toJson();
    }
    if (team != null) {
      map['team'] = team?.toJson();
    }
    if (registrationWithDivisionIdList != null) {
      map['registrationWithDivisionId'] =
          registrationWithDivisionIdList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ProductPurchases {
  ProductPurchases({
    this.id,
    this.variant,
    this.qty,
    this.status,
    this.qrCode,
    this.scanDetails,
    this.userId,
    this.eventId,
    this.productId,
    this.orderNo,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.qrCodeStatus,
  });

  ProductPurchases.fromJson(dynamic json) {
    id = json['_id'];
    variant = json['variant'];
    qty = json['qty'];
    status = json['status'];
    qrCode = json['qr_code'];
    scanDetails = json['scan_details'];
    userId = json['user_id'];
    eventId = json['event_id'];
    productId = json['product_id'];
    orderNo = json['order_no'];
    price = json['price'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    qrCodeStatus = json['qrCodeStatus'];
    product =
        json['product'] != null ? PurchasedProduct.fromJson(json['product']) : null;
  }

  String? id;
  dynamic variant;
  num? qty;
  String? status;
  String? qrCode;
  dynamic scanDetails;
  String? userId;
  String? eventId;
  String? productId;
  String? orderNo;
  num? price;
  String? createdAt;
  String? updatedAt;
  PurchasedProduct? product;
  String? qrCodeStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['variant'] = variant;
    map['qrCodeStatus'] = qrCodeStatus;
    map['qty'] = qty;
    map['status'] = status;
    map['qr_code'] = qrCode;
    map['scan_details'] = scanDetails;
    map['user_id'] = userId;
    map['event_id'] = eventId;
    map['product_id'] = productId;
    map['order_no'] = orderNo;
    map['price'] = price;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }
}
