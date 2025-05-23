import 'dart:io';

import 'package:flutter/material.dart';

import '../../../imports/data.dart';

// rafiaraha04@gmail.com
// Vitec1!12345
class AthleteResponseModel {
  AthleteResponseModel({
    this.status,
    this.responseData,
  });

  AthleteResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? AthleteResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  AthleteResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class AthleteResponseData {
  AthleteResponseData({
    this.message,
    this.assetsUrl,
    this.data,
  });

  AthleteResponseData.fromJson(dynamic json) {
    message = json['message'];
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Athlete.fromJson(v));
      });
    }
  }

  String? message;
  String? assetsUrl;
  List<Athlete>? data;

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

class RequestData {
  RequestData({
    this.id,
    this.accessType,
    this.isSupportRequested,
    this.isAccess,
    this.isAccept,
    this.userId,
    this.athleteId,
    this.createdAt,
    this.updatedAt,
    this.senderName,
  });

  String? id;
  int? accessType;
  String? senderName;
  num? isSupportRequested;
  bool? isAccess;
  dynamic isAccept;
  String? userId;
  String? athleteId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
        id: json["_id"],
        accessType: json["access_type"],
        senderName: json["sender_name"],
        isSupportRequested: json["is_support_requested"],
        isAccess: json["is_access"],
        isAccept: json["is_accept"],
        userId: json["user_id"],
        athleteId: json["athlete_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "access_type": accessType,
        "sender_name": senderName,
        "is_support_requested": isSupportRequested,
        "is_access": isAccess,
        "is_accept": isAccept,
        "user_id": userId,
        "athlete_id": athleteId,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}

class Athlete {
  Athlete({
    this.id,
    this.uniqueId,
    this.grade,
    this.underscoreId,
    this.isExpanded,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.mailingAddress,
    this.pincode,
    this.phoneCode,
    this.phoneNumber,
    this.gender,
    this.city,
    this.state,
    this.email,
    this.birthDate,
    this.age,
    this.createdAt,
    this.updatedAt,
    this.isUserParent,
    this.teamId,
    this.team,
    this.userStatus,
    this.viewers,
    this.coaches,
    this.weightClass,
    this.rank,
    this.rankDivision,
    this.registrations,
    this.awards,
    this.userId,
    this.ownerId,
    this.weight,
    this.noUpcomningEvents,
    this.rankReceived,
    this.membership,
    this.temporaryMembership,
    this.profile,
    this.athleteIdentity,
    this.requestData,
    this.accessType,
    this.senderName,
    this.selectedSeasonPassTitle,
    this.availableSeasonPasses,
    this.isSelected,
    this.athleteStyles,
    this.athleteRegistrationDivision,
    this.noOfRegistrations,
    this.totalRegistrationDivisionCost,
    this.isNotReadyToRegisterWithSelectedWeights,
    this.selectedTeam,
    this.dropDownKey,
    this.isAthleteTaken,
    this.chosenWCs,
    this.canUserEditRegistration,
    this.selectedGrade,
    this.isRedshirt,
    this.maxRegistrations,
    this.totalRegistration,
    this.fileImage,
    this.isLocal,
    this.athIdDivId,
  });

  Athlete.fromJson(dynamic json) {
    id = json['id'];
    uniqueId = json['unique_id'];
    grade = json['grade'];
    isSelected = json['isSelected'];
    isExpanded = json['isExpanded'];
    underscoreId = json['_id'];
    selectedSeasonPassTitle = json['selectedSeasonPassTitle'];
    temporarySeasonPassTitle = json['temporarySeasonPassTitle'];
    availableSeasonPasses = json['temporarySelectedSeasonPassTitle'];
    underscoreId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    mailingAddress = json['mailing_address'];
    pincode = json['pincode'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    city = json['city'];
    state = json['state'];
    email = json['email'];
    birthDate = json['birth_date'];
    age = json['age'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isUserParent = json['is_user_parent'];
    teamId = json['team_id'];
    team = json['team'] != null ? Team.fromJson(json['team']) : null;
    selectedTeam = json['selectedTeam'] != null
        ? Team.fromJson(json['selectedTeam'])
        : null;
    userStatus = json['user_status'];
    viewers = json['viewers'];
    coaches = json['coaches'];
    weightClass = json['weight_class'];
    rank = json['rank'];
    rankDivision = json['rank_division'];
    registrations = json['registrations'];
    awards = json['awards'];
    userId = json['user_id'];
    ownerId = json['owner_id'];
    weight = json['weight'];
    noUpcomningEvents = json['no_upcomning_events'];
    rankReceived = json['rank_received'];
    if (json['style'] != null) {
      athleteStyles = [];
      json['style'].forEach((v) {
        athleteStyles?.add(Styles.fromJson(v));
      });
    }

    if (json['athleteRegistrationDivision'] != null) {
      athleteRegistrationDivision = [];
      json['athleteRegistrationDivision'].forEach((v) {
        athleteRegistrationDivision?.add(RegistrationDivision.fromJson(v));
      });
    }
    membership = json['membership'] != null
        ? Memberships.fromJson(json['membership'])
        : null;
    temporaryMembership = json['temporaryMembership'] != null
        ? Memberships.fromJson(json['temporaryMembership'])
        : null;
    selectedGrade = json['selectedSeasonPassTitle'] != null
        ? GradeData.fromJson(json['selectedSeasonPassTitle'])
        : null;
    profile = json['profile'];
    athleteIdentity = json['athlete_identity'];
    requestData = json['request_data'] != null
        ? RequestData.fromJson(json['request_data'])
        : null;
    accessType = json['access_type'];
    senderName = json['sender_name'];
    canUserEditRegistration = json['canUserEditRegistration'];
    dropDownKey = json['dropDownKey'];
    isInList = json['isInList'];
    noOfRegistrations = json['noOfRegistrations'];
    totalRegistrationDivisionCost = json['totalRegistrationDivisionCost'];
    isAthleteTaken = json['isAthleteTaken'];
    chosenWCs = json['chosenWCs'];
    isLocal = json['isLocal'];
    isRedshirt = json['is_redshirt'];
    maxRegistrations = json['max_registrations'];
    totalRegistration = json['total_registrations'];
    isNotReadyToRegisterWithSelectedWeights =
        json['isReadyToRegisterWithSelectedWeights'];
  }

  String? id;
  String? athIdDivId;
  String? uniqueId;
  String? grade;
  String? underscoreId;
  bool? isExpanded;
  bool? isRedshirt;
  bool? isLocal;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? mailingAddress;
  num? pincode;
  num? phoneCode;
  num? phoneNumber;
  String? gender;
  String? city;
  String? state;
  String? email;
  List<Styles>? athleteStyles;
  List<String>? chosenWCs;
  String? birthDate;
  num? age;
  String? createdAt;
  String? updatedAt;
  bool? isUserParent;
  bool? isSelected;
  bool? isInList;
  bool? isAthleteTaken;
  bool isTakenInThisRegistration = false;
  String? teamId;
  Team? team;
  Team? selectedTeam;
  GradeData? selectedGrade;
  String? userStatus;
  num? viewers;
  num? coaches;
  dynamic weightClass;
  num? rank;
  dynamic rankDivision;
  num? registrations;
  num? awards;
  String? userId;
  String? ownerId;
  dynamic weight;
  num? noUpcomningEvents;
  num? rankReceived;
  Memberships? membership;
  Memberships? temporaryMembership;
  dynamic profile;
  File? fileImage;
  dynamic athleteIdentity;
  RequestData? requestData;
  int? accessType;
  int? noOfRegistrations;
  String? senderName;
  bool? isNotReadyToRegisterWithSelectedWeights;
  bool? canUserEditRegistration;
  String? selectedSeasonPassTitle;
  String? temporarySeasonPassTitle;
  List<String>? availableSeasonPasses;
  List<RegistrationDivision>? athleteRegistrationDivision;
  num? totalRegistrationDivisionCost;
  num? maxRegistrations;
  num? totalRegistration;
  GlobalKey<State<StatefulWidget>>? dropDownKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (athleteRegistrationDivision != null) {
      map['athleteRegistrationDivision'] =
          athleteRegistrationDivision?.map((e) => e.toJson()).toList();
    }
    map['id'] = id;
    map['unique_id'] = uniqueId;
    map['athIdDivId'] = athIdDivId;
    map['grade'] = grade;
    map['isLocal'] = isLocal;
    map['selectedGrade'] = selectedGrade;
    map['chosenWCs'] = chosenWCs;
    map['isExpanded'] = isExpanded;
    map['noOfRegistrations'] = noOfRegistrations;
    map['totalRegistrationDivisionCost'] = totalRegistrationDivisionCost;
    map['_id'] = underscoreId;
    map['isReadyToRegisterWithSelectedWeights'] =
        isNotReadyToRegisterWithSelectedWeights;
    map['isAthleteTaken'] = isAthleteTaken;
    map['is_redshirt'] = isRedshirt;
    map['isInList'] = isInList;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['profile_image'] = profileImage;
    map['mailing_address'] = mailingAddress;
    map['pincode'] = pincode;
    map['phone_code'] = phoneCode;
    map['canUserEditRegistration'] = canUserEditRegistration;
    map['phone_number'] = phoneNumber;
    map['gender'] = gender;
    map['city'] = city;
    map['isSelected'] = isSelected;
    map['state'] = state;
    map['email'] = email;
    map['birth_date'] = birthDate;
    map['age'] = age;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['is_user_parent'] = isUserParent;
    map['team_id'] = teamId;
    map['dropDownKey'] = dropDownKey;
    map['max_registrations'] = maxRegistrations;
    map['total_registrations'] = totalRegistration;
    if (team != null) {
      map['team'] = team?.toJson();
    }
    if (selectedTeam != null) {
      map['selectedTeam'] = selectedTeam?.toJson();
    }
    if (athleteStyles != null) {
      map['style'] = athleteStyles?.map((e) => e.toJson()).toList();
    }
    if (selectedSeasonPassTitle != null) {
      map['selectedSeasonPassTitle'] = selectedSeasonPassTitle;
    }
    if (temporarySeasonPassTitle != null) {
      map['temporarySeasonPassTitle'] = temporarySeasonPassTitle;
    }
    if (availableSeasonPasses != null) {
      map['temporarySelectedSeasonPassTitle'] = availableSeasonPasses;
    }
    map['user_status'] = userStatus;
    map['viewers'] = viewers;
    map['coaches'] = coaches;
    map['weight_class'] = weightClass;
    map['rank'] = rank;
    map['rank_division'] = rankDivision;
    map['registrations'] = registrations;
    map['awards'] = awards;
    map['user_id'] = userId;
    map['owner_id'] = ownerId;
    map['athIdDivId'] = athIdDivId;
    map['weight'] = weight;
    map['no_upcomning_events'] = noUpcomningEvents;
    map['rank_received'] = rankReceived;
    if (membership != null) {
      map['membership'] = membership?.toJson();
    }
    if (temporaryMembership != null) {
      map['temporaryMembership'] = temporaryMembership?.toJson();
    }
    map['profile'] = profile;
    map['athlete_identity'] = athleteIdentity;
    if (requestData != null) {
      map['request_data'] = requestData?.toJson();
    }
    map['access_type'] = accessType;
    map['sender_name'] = senderName;

    return map;
  }
}

class RegistrationDivision {
  String? divisionName;
  String? ageGroupName;
  String? styleName;
  num? totalPriceForFinalisedWeights;
  String? divisionId;
  String? styleId;
  List<String>? finalisedWeights;
  List<String>? finalisedWeightIds;
  List<WeightClass>? finalisedWeightClasses;
  num? guestRegistrationPrice;
  String? teamId;
  Memberships? memberships;

  RegistrationDivision({
    this.divisionId,
    this.styleId,
    this.teamId,
    this.styleName,
    this.ageGroupName,
    this.divisionName,
    this.finalisedWeights,
    this.finalisedWeightIds,
    this.totalPriceForFinalisedWeights,
    this.finalisedWeightClasses,
    this.guestRegistrationPrice,
    this.memberships,
  });

  RegistrationDivision.fromJson(dynamic json) {
    divisionName = json['divisionName'];
    totalPriceForFinalisedWeights = json['totalPriceForFinalisedWeights'];
    memberships = json['membership'] != null
        ? Memberships.fromJson(json['membership'])
        : null;
    ageGroupName = json['ageGroupName'];
    teamId = json['teamId'];
    styleName = json['styleName'];
    divisionId = json['division_id'];
    styleId = json['styleId'];
    guestRegistrationPrice = json['guestRegistrationPrice'];
    if (json['finalisedWeightClasses'] != null) {
      finalisedWeightClasses = [];
      json['data'].forEach((v) {
        finalisedWeightClasses?.map((e) => WeightClass.fromJson(v)).toList();
      });
    }
    if (json['finalisedWeights'] != null) {
      finalisedWeights = [];
      json['finalisedWeights'].forEach((v) {
        finalisedWeights?.add(v);
      });
    }
    if (json['weight_classes'] != null) {
      finalisedWeightIds = [];
      json['weight_classes'].forEach((v) {
        finalisedWeightIds?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['division_id'] = divisionId;
    map['totalPriceForFinalisedWeights'] = totalPriceForFinalisedWeights;
    map['event_division_id'] = styleId;
    map['divisionName'] = divisionName;
    map['ageGroupName'] = ageGroupName;
    map['styleName'] = styleName;
    map['teamId'] = teamId;
    map['weight_classes'] = finalisedWeightIds;
    map['finalisedWeights'] = finalisedWeights;
    map['finalisedWeightClasses'] = finalisedWeightClasses;
    map['guestRegistrationPrice'] = guestRegistrationPrice;
    if (memberships != null) {
      map['membership'] = memberships?.toJson();
    }
    return map;
  }
}
