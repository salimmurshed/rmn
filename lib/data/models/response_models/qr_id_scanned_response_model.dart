import '../../../imports/data.dart';

class QrIdScannedResponseModel {
  QrIdScannedResponseModel({
    this.status,
    this.responseData,
  });

  QrIdScannedResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? QrResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  QrResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class QrResponseData {
  QrResponseData({
    this.message,
    this.data,
    this.qrType,
    this.assetsUrl,
  });

  QrResponseData.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? QrData.fromJson(json['data']) : null;
    qrType = json['qr_type'];
    assetsUrl = json['assets_url'];
  }

  String? message;
  QrData? data;
  String? qrType;
  String? assetsUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['qr_type'] = qrType;
    map['assets_url'] = assetsUrl;
    return map;
  }
}

class QrData {
  QrData({
    this.id,
    this.qty,
    this.scanDetails,
    this.isCancelled,
    this.age,
    this.orderNo,
    this.price,
    this.status,
    this.qrCode,
    this.user,
    this.event,
    this.product,
    this.athlete,
    this.divisionType,
    this.isRedshirt,
    this.style,
    this.weightClass,
    this.division,
    this.ageGroup,
    this.team,
    this.teamId,
    this.isSuccessful,
    this.purchasedVariant,
    this.createdAt,
  });

  QrData.fromJson(dynamic json) {
    id = json['_id'];
    qty = json['qty'];
    status = json['status'];
    purchasedVariant = json['variant'];
    qrCode = json['qr_code'];
    orderNo = json['order_no'];
    price = json['price'];
    isRedshirt = json['is_redshirt'];
    user = json['user'] != null ? DataBaseUser.fromJson(json['user']) : null;
    event = json['event'] != null ? EventData.fromJson(json['event']) : null;
    product =
        json['product'] != null ? Products.fromJson(json['product']) : null;
    scanDetails = json['scan_details'] != null
        ? ScanDetails.fromJson(json['scan_details'])
        : null;
    isCancelled = json['is_cancelled'];
    age = json['age'];
    athlete =
        json['athlete'] != null ? Athlete.fromJson(json['athlete']) : null;
    divisionType = json['division_type'];
    style = json['style'];
    weightClass = json['weight_class'];
    division = json['division'];
    ageGroup = json['age_group'];
    team = json['team'] != null ? Team.fromJson(json['team']) : null;
    teamId = json['team_id'];
    createdAt = json['createdAt'];
    isSuccessful = json['isSuccessful'];
  }

  String? id;
  String? purchasedVariant;
  num? qty;
  String? status;
  String? qrCode;
  String? orderNo;
  num? price;
  bool? isSuccessful;
  bool? isRedshirt;
  DataBaseUser? user;
  EventData? event;
  Products? product;
  ScanDetails? scanDetails;
  bool? isCancelled;
  num? age;
  Athlete? athlete;
  String? divisionType;
  String? style;
  String? weightClass;
  String? division;
  String? ageGroup;
  Team? team;
  String? teamId;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['variant'] = purchasedVariant;
    map['qty'] = qty;
    map['status'] = status;
    map['qr_code'] = qrCode;
    map['order_no'] = orderNo;
    map['is_redshirt'] = isRedshirt;
    map['price'] = price;
    map['isSuccessful'] = isSuccessful;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (event != null) {
      map['event'] = event?.toJson();
    }
    if (product != null) {
      map['product'] = product?.toJson();
    }
    if (scanDetails != null) {
      map['scan_details'] = scanDetails?.toJson();
    }
    map['is_cancelled'] = isCancelled;
    map['age'] = age;
    if (athlete != null) {
      map['athlete'] = athlete?.toJson();
    }
    map['division_type'] = divisionType;
    map['style'] = style;
    map['weight_class'] = weightClass;
    map['division'] = division;
    map['age_group'] = ageGroup;
    if (team != null) {
      map['team'] = team?.toJson();
    }
    map['team_id'] = teamId;
    map['createdAt'] = createdAt;
    return map;
  }
}

class Team {
  Team({
    this.id,
    this.createdAt,
    this.name,
    this.updatedAt,
  });

  Team.fromJson(dynamic json) {
    id = json['_id'];
    createdAt = json['createdAt'];
    name = json['name'];
    updatedAt = json['updatedAt'];
  }

  String? id;
  String? createdAt;
  String? name;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['name'] = name;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class ScanDetails {
  ScanDetails({
    this.scannedAt,
    this.scannedBy,
    this.scannedByUser,
  });

  ScanDetails.fromJson(dynamic json) {
    scannedAt = json['scanned_at'];
    scannedBy = json['scanned_by'];
    scannedByUser = json['scanned_by_user'];
  }

  String? scannedAt;
  String? scannedBy;
  String? scannedByUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['scanned_at'] = scannedAt;
    map['scanned_by'] = scannedBy;
    map['scanned_by_user'] = scannedByUser;
    return map;
  }
}

class Restrictions {
  Restrictions({
    this.maxFreeRegistrations,
    this.excludeEvents,
  });

  Restrictions.fromJson(dynamic json) {
    maxFreeRegistrations = json['max_free_registrations'];
    json['exclude_events'] != null
        ? excludeEvents = json['exclude_events'].cast<String>()
        : [];
  }

  num? maxFreeRegistrations;
  List<String>? excludeEvents;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['max_free_registrations'] = maxFreeRegistrations;
    map['exclude_events'] = excludeEvents;
    return map;
  }
}
