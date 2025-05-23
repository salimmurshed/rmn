
import '../../../imports/data.dart';

class HistoryResponseModel {
  HistoryResponseModel({
    this.status,
    this.responseData,
  });

  HistoryResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? HistoryResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  HistoryResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class HistoryResponseData {
  HistoryResponseData({
    this.total,
    this.page,
    this.perPage,
    this.totalPage,
    this.assetsUrl,
    this.data,
    this.message,
  });

  HistoryResponseData.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    perPage = json['per_page'];
    totalPage = json['total_page'];
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(HistoryData.fromJson(v));
      });
    }
    message = json['message'];
  }

  num? total;
  num? page;
  num? perPage;
  num? totalPage;
  String? assetsUrl;
  List<HistoryData>? data;
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

class HistoryData {
  HistoryData({
    this.id,
    this.scanDetails,
    this.price,
    this.isCancelled,
    this.orderNo,
    this.createdAt,
    this.event,
    this.user,
    this.athlete,
    this.weightClass,
    this.division,
    this.qrType,
    this.product,
    this.variant,
    this.qty,
    this.invoiceUrl,
    this.isDownloaded,
  });

  HistoryData.fromJson(dynamic json) {
    id = json['_id'];
    scanDetails = json['scan_details'] != null
        ? ScanDetails.fromJson(json['scan_details'])
        : null;
    price = json['price'];
    isCancelled = json['is_cancelled'];
    orderNo = json['order_no'];
    createdAt = json['createdAt'];
    event = json['event'] != null ? EventData.fromJson(json['event']) : null;
    user = json['user'] != null ? DataBaseUser.fromJson(json['user']) : null;
    athlete = json['athlete'] != null ? Athlete.fromJson(json['athlete']) : null;
    weightClass = json['weight_class'] != null
        ? WeightClass.fromJson(json['weight_class'])
        : null;
    division = json['division'] != null ? Division.fromJson(json['division']) : null;
    qrType = json['qr_type'];
    product = json['product'] != null ? HistoryProduct.fromJson(json['product']) : null;
    variant = json['variant'];
    qty = json['qty'];
    invoiceUrl = json['invoice_url'];
    isDownloaded = json['isDownloaded'];
  }

  String? id;
  ScanDetails? scanDetails;
  num? price;
  bool? isCancelled;
  bool? isDownloaded;
  String? orderNo;
  String? createdAt;
  EventData? event;
  DataBaseUser? user;
  Athlete? athlete;
  WeightClass? weightClass;
  Division? division;
  String? qrType;
  HistoryProduct? product;
  String? variant;
  num? qty;
  String? invoiceUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (scanDetails != null) {
      map['scan_details'] = scanDetails?.toJson();
    }
    map['price'] = price;
    map['is_cancelled'] = isCancelled;
    map['order_no'] = orderNo;
    map['isDownloaded'] = isDownloaded;
    map['createdAt'] = createdAt;
    if (event != null) {
      map['event'] = event?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (athlete != null) {
      map['athlete'] = athlete?.toJson();
    }
    if (weightClass != null) {
      map['weight_class'] = weightClass?.toJson();
    }
    if (division != null) {
      map['division'] = division?.toJson();
    }
    map['qr_type'] = qrType;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    map['variant'] = variant;
    map['qty'] = qty;
    map['invoice_url'] = invoiceUrl;
    return map;
  }
}

class Division {
  Division({
    this.id,
    this.divisionType,
    this.style,
    this.title,
  });

  Division.fromJson(dynamic json) {
    id = json['_id'];
    divisionType = json['division_type'];
    style = json['style'];
    title = json['title'];
  }

  String? id;
  String? divisionType;
  String? style;
  String? title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['division_type'] = divisionType;
    map['style'] = style;
    map['title'] = title;
    return map;
  }
}











class HistoryProduct {
  HistoryProduct({
    this.id,
    this.image,
    this.title,
  });

  HistoryProduct.fromJson(dynamic json) {
    id = json['_id'];
    image = json['image'];
    title = json['title'];
  }

  String? id;
  String? image;
  String? title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['image'] = image;
    map['title'] = title;
    return map;
  }
}