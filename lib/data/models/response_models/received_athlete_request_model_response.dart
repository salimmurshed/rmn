import '../../../imports/data.dart';

class ReceivedAthleteRequestModelResponse {
  ReceivedAthleteRequestModelResponse({
    this.status,
    this.responseData,
  });

  ReceivedAthleteRequestModelResponse.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? ReceivedAthleteRequestResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  ReceivedAthleteRequestResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class ReceivedAthleteRequestResponseData {
  ReceivedAthleteRequestResponseData({
    this.message,
    this.assetsUrl,
    this.data,
  });

  ReceivedAthleteRequestResponseData.fromJson(dynamic json) {
    message = json['message'];
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ReceivedAthleteRequestData.fromJson(v));
      });
    }
  }

  String? message;
  String? assetsUrl;
  List<ReceivedAthleteRequestData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['assets_url'] = assetsUrl;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ReceivedAthleteRequestData {
  ReceivedAthleteRequestData({
    this.id,
    this.athleteId,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.age,
    this.birthDate,
    this.noUpcomningEvents,
    this.rankReceived,
    this.awards,
    this.weightClass,
    this.membership,
    this.accessType,
    this.senderName,
  });

  ReceivedAthleteRequestData.fromJson(dynamic json) {
    id = json['_id'];
    athleteId = json['athlete_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    age = json['age'];
    birthDate = json['birth_date'];
    noUpcomningEvents = json['no_upcomning_events'];
    rankReceived = json['rank_received'];
    awards = json['awards'];
    weightClass = json['weight_class'];
    membership = json['membership'] != null
        ? Memberships.fromJson(json['membership'])
        : null;
    accessType = json['access_type'];
    senderName = json['sender_name'];
  }

  String? id;
  String? athleteId;
  String? firstName;
  String? lastName;
  String? profileImage;
  num? age;
  String? birthDate;
  num? noUpcomningEvents;
  num? rankReceived;
  num? awards;
  dynamic weightClass;
  Memberships? membership;
  int? accessType;
  String? senderName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['athlete_id'] = athleteId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['profile_image'] = profileImage;
    map['age'] = age;
    map['birth_date'] = birthDate;
    map['no_upcomning_events'] = noUpcomningEvents;
    map['rank_received'] = rankReceived;
    map['awards'] = awards;
    map['weight_class'] = weightClass;
    if (membership != null) {
      map['membership'] = membership?.toJson();
    }
    map['access_type'] = accessType;
    map['sender_name'] = senderName;
    return map;
  }
}
