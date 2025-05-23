class RankResponseModel {
  RankResponseModel({
    this.status,
    this.responseData,
  });

  RankResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? ResponseRankData.fromJson(json['responseData'])
        : null;
  }
  bool? status;
  ResponseRankData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class ResponseRankData {
  ResponseRankData({
    this.message,
    this.assetsUrl,
    this.placements,
  });

  ResponseRankData.fromJson(dynamic json) {
    message = json['message'];
    assetsUrl = json['assets_url'];
    if (json['placements'] != null) {
      placements = [];
      json['placements'].forEach((v) {
        placements?.add(Placements.fromJson(v));
      });
    }
  }
  String? message;
  String? assetsUrl;
  List<Placements>? placements;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['assets_url'] = assetsUrl;
    if (placements != null) {
      map['placements'] = placements?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Placements {
  Placements({
    this.divisionType,
    this.divisions,
  });

  Placements.fromJson(dynamic json) {
    divisionType = json['division_type'];
    if (json['divisions'] != null) {
      divisions = [];
      json['divisions'].forEach((v) {
        divisions?.add(DivisionsRank.fromJson(v));
      });
    }
  }
  String? divisionType;
  List<DivisionsRank>? divisions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['division_type'] = divisionType;
    if (divisions != null) {
      map['divisions'] = divisions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class DivisionsRank {
  DivisionsRank({
    this.id,
    this.title,
    this.weightClasses,
    this.isExpanded,
  });

  DivisionsRank.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    isExpanded = false;
    if (json['weight_classes'] != null) {
      weightClasses = [];
      json['weight_classes'].forEach((v) {
        weightClasses?.add(WeightClassesRank.fromJson(v));
      });
    }
  }
  String? id;
  String? title;
  bool? isExpanded;
  List<WeightClassesRank>? weightClasses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['isExpanded'] = false;
    map['title'] = title;
    if (weightClasses != null) {
      map['weight_classes'] = weightClasses?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class WeightClassesRank {
  WeightClassesRank({
    this.athletes,
    this.divisionType,
    this.divisionId,
    this.weightClassId,
    this.weightClass,
    this.isExpanded,
  });

  WeightClassesRank.fromJson(dynamic json) {
    if (json['athletes'] != null) {
      athletes = [];
      json['athletes'].forEach((v) {
        athletes?.add(AthletesRank.fromJson(v));
      });
    }
    divisionType = json['division_type'];
    divisionId = json['division_id'];
    isExpanded = false;
    weightClassId = json['weight_class_id'];
    weightClass = json['weight_class'] != null
        ? WeightClassRank.fromJson(json['weight_class'])
        : null;
  }
  List<AthletesRank>? athletes;
  String? divisionType;
  bool? isExpanded;
  String? divisionId;
  String? weightClassId;
  WeightClassRank? weightClass;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (athletes != null) {
      map['athletes'] = athletes?.map((v) => v.toJson()).toList();
    }
    map['division_type'] = divisionType;
    map['isExpanded'] = false;
    map['division_id'] = divisionId;
    map['weight_class_id'] = weightClassId;
    if (weightClass != null) {
      map['weight_class'] = weightClass?.toJson();
    }
    return map;
  }
}

class WeightClassRank {
  WeightClassRank({
    this.id,
    this.weight,
  });

  WeightClassRank.fromJson(dynamic json) {
    id = json['_id'];
    weight = json['weight'];
  }
  String? id;
  dynamic weight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['weight'] = weight;
    return map;
  }
}

class AthletesRank {
  AthletesRank({
    this.id,
    this.athleteId,
    this.divisionId,
    this.weightClassId,
    this.rank,
    this.divisionType,
    this.createdAt,
    this.updatedAt,
    this.athleteDetails,
    this.accessType,
  });

  AthletesRank.fromJson(dynamic json) {
    id = json['_id'];
    athleteId = json['athlete_id'];
    divisionId = json['division_id'];
    weightClassId = json['weight_class_id'];
    rank = json['rank'];
    divisionType = json['division_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    athleteDetails = json['athlete_details'] != null
        ? AthleteDetailsRank.fromJson(json['athlete_details'])
        : null;
    accessType = json['access_type'];
  }
  String? id;
  String? athleteId;
  String? divisionId;
  String? weightClassId;
  int? rank;
  String? divisionType;
  String? createdAt;
  String? updatedAt;
  AthleteDetailsRank? athleteDetails;
  dynamic accessType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['athlete_id'] = athleteId;
    map['division_id'] = divisionId;
    map['weight_class_id'] = weightClassId;
    map['rank'] = rank;
    map['division_type'] = divisionType;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (athleteDetails != null) {
      map['athlete_details'] = athleteDetails?.toJson();
    }
    map['access_type'] = accessType;
    return map;
  }
}

class AthleteDetailsRank {
  AthleteDetailsRank({
    this.id,
    this.ownerId,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.weight,
    this.profileImage,
    this.age,
  });

  AthleteDetailsRank.fromJson(dynamic json) {
    id = json['_id'];
    ownerId = json['owner_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    birthDate = json['birth_date'];
    weight = json['weight'];
    profileImage = json['profile_image'];
    age = json['age'];
  }
  String? id;
  String? ownerId;
  String? firstName;
  String? lastName;
  String? birthDate;
  dynamic weight;
  String? profileImage;
  dynamic age;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['owner_id'] = ownerId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['birth_date'] = birthDate;
    map['weight'] = weight;
    map['profile_image'] = profileImage;
    map['age'] = age;
    return map;
  }
}
