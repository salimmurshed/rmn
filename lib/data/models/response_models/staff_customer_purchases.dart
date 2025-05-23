import 'package:rmnevents/data/models/response_models/qr_id_scanned_response_model.dart';

import '../../../imports/data.dart';

class StaffCustomerPurchases {
  bool? status;
  StaffCustomerPurchaseResponseData? responseData;

  StaffCustomerPurchases({this.status, this.responseData});

  StaffCustomerPurchases.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? StaffCustomerPurchaseResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (responseData != null) {
      data['responseData'] = responseData!.toJson();
    }
    return data;
  }
}

class StaffCustomerPurchaseResponseData {
  String? assetsUrl;
  StaffCustomerPurchaseData? data;
  String? message;

  StaffCustomerPurchaseResponseData({this.assetsUrl, this.data, this.message});

  StaffCustomerPurchaseResponseData.fromJson(Map<String, dynamic> json) {
    assetsUrl = json['assets_url'];
    data = json['data'] != null
        ? StaffCustomerPurchaseData.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assets_url'] = assetsUrl;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class StaffCustomerPurchaseData {
  List<CustomerProducts>? products;
  List<CustomerRegistrations>? registrations;

  StaffCustomerPurchaseData({this.products, this.registrations});

  StaffCustomerPurchaseData.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <CustomerProducts>[];
      json['products'].forEach((v) {
        products!.add(CustomerProducts.fromJson(v));
      });
    }
    if (json['registrations'] != null) {
      registrations = <CustomerRegistrations>[];
      json['registrations'].forEach((v) {
        registrations!.add(CustomerRegistrations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (registrations != null) {
      data['registrations'] = registrations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerProducts {
  String? sId;
  String? variant;
  String? qrCode;
  String? qrCodeImage;
  ScanDetails? scanDetails;
  String? orderNo;
  num? price;
  String? createdAt;
  Product? product;
  bool? isCancelled;
  bool? isMarkedScanned;

  CustomerProducts(
      {this.sId,
      this.variant,
      this.qrCode,
      this.qrCodeImage,
      this.scanDetails,
      this.isMarkedScanned,
      this.orderNo,
      this.price,
      this.createdAt,
      this.product,
      this.isCancelled});

  CustomerProducts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    variant = json['variant'];
    qrCode = json['qr_code'];
    qrCodeImage = json['qr_code_image'];
    isMarkedScanned = json['is_marked_scanned'];
    scanDetails = json['scan_details'] != null
        ? ScanDetails.fromJson(json['scan_details'])
        : null;
    orderNo = json['order_no'];
    price = json['price'];
    createdAt = json['createdAt'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    isCancelled = json['is_cancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['variant'] = variant;
    data['qr_code'] = qrCode;
    data['qr_code_image'] = qrCodeImage;
    data['is_marked_scanned'] = isMarkedScanned;
    if (scanDetails != null) {
      data['scan_details'] = scanDetails!.toJson();
    }
    data['order_no'] = orderNo;
    data['price'] = price;
    data['createdAt'] = createdAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['is_cancelled'] = isCancelled;
    return data;
  }
}

class Product {
  String? sId;
  String? image;
  String? title;

  Product({this.sId, this.image, this.title});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['image'] = image;
    data['title'] = title;
    return data;
  }
}

class CustomerRegistrations {
  String? sId;
  ScanDetails? scanDetails;
  String? qrCode;
  String? qrCodeImage;
  num? price;
  String? orderNo;
  String? createdAt;
  Athlete? athlete;
  Division? division;
  WeightClass? weightClass;
  bool? isCancelled;
  bool? isMarkedScanned;

  CustomerRegistrations(
      {this.sId,
      this.scanDetails,
      this.isMarkedScanned,
      this.qrCode,
      this.qrCodeImage,
      this.price,
      this.orderNo,
      this.createdAt,
      this.athlete,
      this.division,
      this.weightClass,
      this.isCancelled});

  CustomerRegistrations.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    scanDetails = json['scan_details'] != null
        ? ScanDetails.fromJson(json['scan_details'])
        : null;
    qrCode = json['qr_code'];
    qrCodeImage = json['qr_code_image'];
    isMarkedScanned = json['is_marked_scanned'];
    price = json['price'];
    orderNo = json['order_no'];
    createdAt = json['createdAt'];
    athlete =
        json['athlete'] != null ? Athlete.fromJson(json['athlete']) : null;
    division =
        json['division'] != null ? Division.fromJson(json['division']) : null;
    weightClass = json['weight_class'] != null
        ? WeightClass.fromJson(json['weight_class'])
        : null;
    isCancelled = json['is_cancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (scanDetails != null) {
      data['scan_details'] = scanDetails!.toJson();
    }
    data['qr_code'] = qrCode;
    data['is_marked_scanned'] = isMarkedScanned;
    data['qr_code_image'] = qrCodeImage;
    data['price'] = price;
    data['order_no'] = orderNo;
    data['createdAt'] = createdAt;
    if (athlete != null) {
      data['athlete'] = athlete!.toJson();
    }
    if (division != null) {
      data['division'] = division!.toJson();
    }
    if (weightClass != null) {
      data['weight_class'] = weightClass!.toJson();
    }
    data['is_cancelled'] = isCancelled;
    return data;
  }
}
