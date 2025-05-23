import '../../../imports/data.dart';

class AthleteDetailsEventsResponseModel {
  AthleteDetailsEventsResponseModel({
    this.status,
    this.responseData,
  });

  AthleteDetailsEventsResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? AthleteDetailsEventsSeasonWiseForAthleteResponseData.fromJson(
            json['responseData'])
        : null;
  }

  bool? status;
  AthleteDetailsEventsSeasonWiseForAthleteResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class AthleteDetailsEventsSeasonWiseForAthleteResponseData {
  AthleteDetailsEventsSeasonWiseForAthleteResponseData({
    this.events,
    this.assetsUrl,
    this.message,
  });

  AthleteDetailsEventsSeasonWiseForAthleteResponseData.fromJson(dynamic json) {
    if (json['events'] != null) {
      events = [];
      json['events'].forEach((v) {
        events?.add(EventsSeasonWiseForAthlete.fromJson(v));
      });
    }
    assetsUrl = json['assets_url'];
    message = json['message'];
  }

  List<EventsSeasonWiseForAthlete>? events;
  String? assetsUrl;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (events != null) {
      map['events'] = events?.map((v) => v.toJson()).toList();
    }
    map['assets_url'] = assetsUrl;
    map['message'] = message;
    return map;
  }
}

class EventsSeasonWiseForAthlete {
  EventsSeasonWiseForAthlete({
    this.id,
    this.address,
    this.endDatetime,
    this.startDatetime,
    this.timezone,
    this.title,
    this.slug,
    this.mainImage,
    this.registrations,
    this.registrationWithDivisionIdList,
    this.placement,
  });

  EventsSeasonWiseForAthlete.fromJson(dynamic json) {
    id = json['_id'];
    address = json['address'];
    timezone = json['timezone'];
    endDatetime = json['end_datetime'];
    startDatetime = json['start_datetime'];
    title = json['title'];
    slug = json['slug'];
    mainImage = json['main_image'];
    if (json['registrations'] != null) {
      registrations = [];
      json['registrations'].forEach((v) {
        registrations?.add(Registrations.fromJson(v));
      });
    }
    if (json['registrationWithDivisionId'] != null) {
      registrationWithDivisionIdList = [];
      json['registrationWithDivisionId'].forEach((v) {
        registrationWithDivisionIdList
            ?.add(RegistrationWithSameDivisionId.fromJson(v));
      });
    }
    placement = json['placement'];
  }

  String? id;
  String? address;
  String? endDatetime;
  String? startDatetime;
  String? timezone;
  String? title;
  String? slug;
  String? mainImage;
  List<Registrations>? registrations;
  List<RegistrationWithSameDivisionId>? registrationWithDivisionIdList;
  num? placement;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['address'] = address;
    map['end_datetime'] = endDatetime;
    map['start_datetime'] = startDatetime;
    map['timezone'] = timezone;
    map['title'] = title;
    map['slug'] = slug;
    map['main_image'] = mainImage;
    if (registrations != null) {
      map['registrations'] = registrations?.map((v) => v.toJson()).toList();
    }
    if (registrationWithDivisionIdList != null) {
      map['registrationWithDivisionId'] =
          registrationWithDivisionIdList?.map((v) => v.toJson()).toList();
    }
    map['placement'] = placement;
    return map;
  }
}

class Division {
  Division(
      {this.id,
      this.createdAt,
      this.divisionType,
      this.title,
      this.updatedAt,
      this.style,
      this.maxDate,
      this.minAge,
      this.maxAge,
      this.athletes,
      this.availableWeightsPerStyle,
      this.weightClasses,
      this.guestRegistrationPrice});

  String? id;
  String? createdAt;
  String? divisionType;
  String? title;
  String? updatedAt;
  String? style;
  String? maxDate;
  num? minAge;
  num? maxAge;
  List<Athlete>? athletes;
  List<WeightClass>? weightClasses;
  List<String>? availableWeightsPerStyle;
  num? guestRegistrationPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['division_type'] = divisionType;
    map['title'] = title;
    map['updatedAt'] = updatedAt;
    map['style'] = style;
    map['max_date'] = maxDate;
    map['min_age'] = minAge;
    map['max_age'] = maxAge;
    if (athletes != null) {
      map['athletes'] = athletes?.map((v) => v.toJson()).toList();
    }
    if (availableWeightsPerStyle != null) {
      map['availableWeightsPerStyle'] =
          availableWeightsPerStyle?.map((v) => v).toList();
    }
    if (weightClasses != null) {
      map['weight_classes'] = weightClasses?.map((v) => v.toJson()).toList();
    }
    map['guest_registration_price'] = guestRegistrationPrice;
    return map;
  }

  Division.fromJson(dynamic json) {
    id = json['_id'];
    createdAt = json['createdAt'];
    divisionType = json['division_type'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    style = json['style'];
    maxDate = json['max_date'];
    minAge = json['min_age'];
    maxAge = json['max_age'];
    if (json['athletes'] != null) {
      athletes = [];
      json['athletes'].forEach((v) {
        athletes?.add(Athlete.fromJson(v));
      });
    }
    if (json['availableWeightsPerStyle'] != null) {
      availableWeightsPerStyle = [];
      json['availableWeightsPerStyle'].forEach((v) {
        availableWeightsPerStyle?.add(v);
      });
    }
    if (json['weight_classes'] != null) {
      weightClasses = [];
      json['weight_classes'].forEach((v) {
        weightClasses?.add(WeightClass.fromJson(v));
      });
    }
    guestRegistrationPrice = json['guest_registration_price'];
  }
}

class RegistrationWithSameDivisionId {
  Division? division;
  List<String>? registeredWeightClasses;
  List<String>? selectedWeightClasses;
  List<String>? availableWeightClasses;
  List<WeightClass>? weightClasses;
  List<String>? scannedWeights;
  bool? isCancelled;

  RegistrationWithSameDivisionId({
    this.division,
    this.registeredWeightClasses,
    this.selectedWeightClasses,
    this.availableWeightClasses,
    this.weightClasses,
    this.scannedWeights,
    this.isCancelled,
  });

  RegistrationWithSameDivisionId.fromJson(dynamic json) {
    division =
        json['division'] != null ? Division.fromJson(json['division']) : null;
    if (json['registeredWeightClasses'] != null) {
      registeredWeightClasses = List<String>.from(
          json['registeredWeightClasses'].map((v) => v.toString()));
    }
    if (json['selectedWeightClasses'] != null) {
      selectedWeightClasses = List<String>.from(
          json['selectedWeightClasses'].map((v) => v.toString()));
    }
    if (json['weightClasses'] != null) {
      weightClasses = [];
      json['weightClasses'].forEach((v) {
        weightClasses?.add(WeightClass.fromJson(v));
      });
    }

    if (json['availableWeightClasses'] != null) {
      availableWeightClasses = List<String>.from(
          json['availableWeightClasses'].map((v) => v.toString()));
    }
    if (json['scannedWeights'] != null) {
      scannedWeights =
          List<String>.from(json['scannedWeights'].map((v) => v.toString()));
    }
    isCancelled = json['isCancelled'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (division != null) {
      map['division'] = division?.toJson();
    }
    map['registeredWeightClasses'] = registeredWeightClasses;
    map['isCancelled'] = isCancelled;
    map['selectedWeightClasses'] = selectedWeightClasses;
    map['availableWeightClasses'] = availableWeightClasses;
    map['scannedWeights'] = scannedWeights;
    if (weightClasses != null) {
      map['weightClasses'] = weightClasses?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
