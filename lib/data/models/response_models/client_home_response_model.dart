import '../../../imports/data.dart';

class ClientHomeResponseModel {
  ClientHomeResponseModel({
    this.status,
    this.responseData,
  });

  ClientHomeResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? ClientHomeResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  ClientHomeResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class ClientHomeResponseData {
  ClientHomeResponseData({
    this.liveEvent,
    this.upcomingRegistrations,
    this.assetsUrl,
    this.message,
  });

  ClientHomeResponseData.fromJson(dynamic json) {
    liveEvent = json['live_event'] != null
        ? EventData.fromJson(json['live_event'])
        : null;
    if (json['upcoming_registrations'] != null) {
      upcomingRegistrations = [];
      json['upcoming_registrations'].forEach((v) {
        upcomingRegistrations?.add(UpcomingRegistrations.fromJson(v));
      });
    }
    assetsUrl = json['assets_url'];
    message = json['message'];
  }

  EventData? liveEvent;
  List<UpcomingRegistrations>? upcomingRegistrations;
  String? assetsUrl;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (liveEvent != null) {
      map['live_event'] = liveEvent?.toJson();
    }
    if (upcomingRegistrations != null) {
      map['upcoming_registrations'] =
          upcomingRegistrations?.map((v) => v.toJson()).toList();
    }
    map['assets_url'] = assetsUrl;
    map['message'] = message;
    return map;
  }
}

class UpcomingRegistrations {
  UpcomingRegistrations({
    this.underscoreId,
    this.slug,
    this.coverImage,
    this.mainImage,
    this.address,
    this.endDatetime,
    this.startDatetime,
    this.timezone,
    this.title,
    this.athletes,
    this.athleteProfiles,
    this.eventRegistrationLimit
  });

  UpcomingRegistrations.fromJson(dynamic json) {
    underscoreId = json['_id'];
    slug = json['slug'];
    coverImage = json['cover_image'];
    mainImage = json['main_image'];
    timezone = json['timezone'];
    address = json['address'];
    endDatetime = json['end_datetime'];
    startDatetime = json['start_datetime'];
    title = json['title'];
    athleteProfiles = json['athleteProfiles'];
    eventRegistrationLimit = json['event_registration_limit'];
    if (json['athletes'] != null) {
      athletes = [];
      json['athletes'].forEach((v) {
        athletes?.add(Athlete.fromJson(v));
      });
    }
  }

  String? underscoreId;
  String? slug;
  String? coverImage;
  String? mainImage;
  String? address;
  String? endDatetime;
  String? startDatetime;
  String? timezone;
  String? title;
  num? eventRegistrationLimit;
  List<Athlete>? athletes;
  List<String>? athleteProfiles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = underscoreId;
    map['slug'] = slug;
    map['cover_image'] = coverImage;
    map['main_image'] = mainImage;
    map['address'] = address;
    map['end_datetime'] = endDatetime;
    map['start_datetime'] = startDatetime;
    map['timezone'] = timezone;
    map['title'] = title;
    map['athleteProfiles'] = athleteProfiles;
    map['event_registration_limit'] = eventRegistrationLimit;
    if (athletes != null) {
      map['athletes'] = athletes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}



class Registrations {
  Registrations({
    this.id,
    this.underscoreId,
    this.teamId,
    this.isCancelled,
    this.userId,
    this.eventId,
    this.athleteId,
    this.eventDivisionId,
    this.divisionId,
    this.orderNo,
    this.weightClassId,
    this.age,
    this.createdAt,
    this.updatedAt,
    this.division,
    this.weightClass,
    this.eventDivisionType,
    this.eventDivisionStyle,
    this.scanDetails,
    this.qrCode,
    this.price,
    this.athlete,
    this.qrCodeStatus,

  });

  Registrations.fromJson(dynamic json) {
    id = json['id'];
    underscoreId = json['_id'];
    teamId = json['team_id'];
    isCancelled = json['is_cancelled'];
    userId = json['user_id'];
    eventId = json['event_id'];
    athleteId = json['athlete_id'];
    eventDivisionId = json['event_division_id'];
    divisionId = json['division_id'];
    orderNo = json['order_no'];
    weightClassId = json['weight_class_id'];
    age = json['age'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    qrCodeStatus = json['qrCodeStatus'];
    division =
    json['division'] != null ? Division.fromJson(json['division']) : null;
    weightClass = json['weight_class'] != null
        ? WeightClass.fromJson(json['weight_class'])
        : null;
    eventDivisionType = json['event_division_type'];
    eventDivisionStyle = json['event_division_style'];
    scanDetails = json['scan_details'] != null ? ScanDetails.fromJson(json['scan_details']) : null;
    qrCode = json['qr_code'];
    price = json['price'];
    athlete =
        json['athletes'] != null ? Athlete.fromJson(json['athletes']) : null;

  }

  String? teamId;
  ScanDetails? scanDetails;
  String? qrCode;
  num? price;
  bool? isCancelled;
  String? underscoreId;
  String? qrCodeStatus;
  String? userId;
  String? eventId;
  String? athleteId;
  String? eventDivisionId;
  String? divisionId;
  String? orderNo;
  String? weightClassId;
  num? age;
  String? createdAt;
  String? updatedAt;
  Athlete? athlete;
  String? id;
  Division? division;
  WeightClass? weightClass;
  String? eventDivisionType;
  String? eventDivisionStyle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = underscoreId;
    map['id'] = id;
    map['qrCodeStatus'] = qrCodeStatus;
    map['team_id'] = teamId;
    map['is_cancelled'] = isCancelled;
    map['user_id'] = userId;
    map['event_id'] = eventId;
    map['athlete_id'] = athleteId;
    map['event_division_id'] = eventDivisionId;
    map['division_id'] = divisionId;
    map['order_no'] = orderNo;
    map['weight_class_id'] = weightClassId;
    map['age'] = age;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['scan_details'] = scanDetails;
    map['qr_code'] = qrCode;
    map['price'] = price;
    if (scanDetails != null) {
      map['scan_details'] = scanDetails?.toJson();
    }
    if (athlete != null) {
      map['athletes'] = athlete?.toJson();
    }
    if (division != null) {
      map['division'] = division?.toJson();
    }
    if (weightClass != null) {
      map['weight_class'] = weightClass?.toJson();
    }
    map['event_division_type'] = eventDivisionType;
    map['event_division_style'] = eventDivisionStyle;

    return map;
  }
}


