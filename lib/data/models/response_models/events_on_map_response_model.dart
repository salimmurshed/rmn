import '../../../imports/common.dart';
import '../../../imports/data.dart';

class EventsOnMapResponseModel {
  EventsOnMapResponseModel({
      this.status, 
      this.responseData,});

  EventsOnMapResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? EventsOnMapResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  EventsOnMapResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class EventsOnMapResponseData {
  EventsOnMapResponseData({
      this.message, 
      this.assetsUrl, 
      this.events,});

  EventsOnMapResponseData.fromJson(dynamic json) {
    message = json['message'];
    assetsUrl = json['assets_url'];
    if (json['events'] != null) {
      events = [];
      json['events'].forEach((v) {
        events?.add(MapEvents.fromJson(v));
      });
    }
  }
  String? message;
  String? assetsUrl;
  List<MapEvents>? events;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['assets_url'] = assetsUrl;
    if (events != null) {
      map['events'] = events?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class MapEvents {
  MapEvents({
      this.id, 
      this.slug, 
      this.shortDesc, 
      this.coverImage, 
      this.mainImage, 
      this.startTime, 
      this.scheduleOverview, 
      this.schedules, 
      this.divisionGuidelines, 
      this.timezone, 
      this.season, 
      this.guestRegistrationPrice, 
      this.liveStreamUrl, 
      //this.sentNotifications,
      this.isDisabled, 
      this.isRegistrationAvailable, 
      this.coordinates, 
      this.address, 
      this.city, 
      this.createdAt, 
      this.endDatetime, 
      this.pincode, 
      this.startDatetime, 
      this.state, 
      this.title, 
      this.updatedAt, 
      this.guestRegistrationPrices, 
      this.isArchived, 
      this.registrationTab,
    this.eventInDays,
    this.eventStatus,
      this.links,});

  MapEvents.fromJson(dynamic json) {
    id = json['_id'];
    slug = json['slug'];
    eventInDays = json['eventInDays'];
    eventStatus = json['eventStatus'];
    shortDesc = json['short_desc'];
    coverImage = json['cover_image'];
    mainImage = json['main_image'];
    startTime = json['start_time'];
    scheduleOverview = json['schedule_overview'];
    schedules = json['schedules'] != null ? json['schedules'].cast<String>() : [];
    divisionGuidelines = json['division_guidelines'];
    timezone = json['timezone'];
    season = json['season'];
    guestRegistrationPrice = json['guest_registration_price'];
    liveStreamUrl = json['live_stream_url'];
    // if (json['sent_notifications'] != null) {
    //   sentNotifications = [];
    //   json['sent_notifications'].forEach((v) {
    //     sentNotifications?.add(Dynamic.fromJson(v));
    //   });
    // }
    isDisabled = json['is_disabled'];
    isRegistrationAvailable = json['is_registration_available'];
    coordinates = json['coordinates'] != null ? Coordinates.fromJson(json['coordinates']) : null;
    address = json['address'];
    city = json['city'];
    createdAt = json['createdAt'];
    endDatetime = json['end_datetime'];
    pincode = json['pincode'];
    startDatetime = json['start_datetime'];
    state = json['state'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    if (json['guest_registration_prices'] != null) {
      guestRegistrationPrices = [];
      json['guest_registration_prices'].forEach((v) {
        guestRegistrationPrices?.add(GuestRegistrationPrices.fromJson(v));
      });
    }
    isArchived = json['is_archived'];
    registrationTab = json['registration_tab'] != null ? RegistrationTab.fromJson(json['registration_tab']) : null;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
  }
  String? id;
  String? slug;
  String? shortDesc;
  String? coverImage;
  String? mainImage;
  String? startTime;
  String? scheduleOverview;
  List<String>? schedules;
  dynamic divisionGuidelines;
  String? timezone;
  String? season;
  num? guestRegistrationPrice;
  dynamic liveStreamUrl;
  EventStatus? eventStatus;
  String? eventInDays;
  // List<dynamic>? sentNotifications;
  bool? isDisabled;
  bool? isRegistrationAvailable;
  Coordinates? coordinates;
  String? address;
  String? city;
  String? createdAt;
  String? endDatetime;
  String? pincode;
  String? startDatetime;
  String? state;
  String? title;
  String? updatedAt;
  List<GuestRegistrationPrices>? guestRegistrationPrices;
  bool? isArchived;
  RegistrationTab? registrationTab;
  Links? links;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['slug'] = slug;
    map['short_desc'] = shortDesc;
    map['cover_image'] = coverImage;
    map['main_image'] = mainImage;
    map['start_time'] = startTime;
    map['schedule_overview'] = scheduleOverview;
    map['schedules'] = schedules;
    map['division_guidelines'] = divisionGuidelines;
    map['timezone'] = timezone;
    map['season'] = season;
    map['guest_registration_price'] = guestRegistrationPrice;
    map['live_stream_url'] = liveStreamUrl;
    // if (sentNotifications != null) {
    //   map['sent_notifications'] = sentNotifications?.map((v) => v.toJson()).toList();
    // }
    map['is_disabled'] = isDisabled;
    map['is_registration_available'] = isRegistrationAvailable;
    if (coordinates != null) {
      map['coordinates'] = coordinates?.toJson();
    }
    map['address'] = address;
    map['city'] = city;
    map['createdAt'] = createdAt;
    map['end_datetime'] = endDatetime;
    map['pincode'] = pincode;
    map['start_datetime'] = startDatetime;
    map['state'] = state;
    map['title'] = title;
    map['eventStatus'] = eventStatus;
    map['eventInDays'] = eventInDays;
    map['updatedAt'] = updatedAt;
    if (guestRegistrationPrices != null) {
      map['guest_registration_prices'] = guestRegistrationPrices?.map((v) => v.toJson()).toList();
    }
    map['is_archived'] = isArchived;
    if (registrationTab != null) {
      map['registration_tab'] = registrationTab?.toJson();
    }
    if (links != null) {
      map['links'] = links?.toJson();
    }
    return map;
  }

}







class GuestRegistrationPrices {
  GuestRegistrationPrices({
      this.id, 
      this.divisionType, 
      this.style, 
      this.price,});

  GuestRegistrationPrices.fromJson(dynamic json) {
    id = json['_id'];
    divisionType = json['division_type'];
    style = json['style'];
    price = json['price'];
  }
  String? id;
  String? divisionType;
  String? style;
  num? price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['division_type'] = divisionType;
    map['style'] = style;
    map['price'] = price;
    return map;
  }

}

class Coordinates {
  Coordinates({
      this.type, 
      this.coordinates,});

  Coordinates.fromJson(dynamic json) {
    type = json['type'];
    coordinates = json['coordinates'] != null ? json['coordinates'].cast<num>() : [];
  }
  String? type;
  List<num>? coordinates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['coordinates'] = coordinates;
    return map;
  }

}