import '../../../imports/data.dart';

class AthleteDetailsRankResponseModel {
  AthleteDetailsRankResponseModel({
    this.status,
    this.responseData,
  });

  AthleteDetailsRankResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? RankResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  RankResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class RankResponseData {
  RankResponseData({
    this.ranks,
    this.assetsUrl,
    this.message,
  });

  RankResponseData.fromJson(dynamic json) {
    if (json['ranks'] != null) {
      ranks = [];
      json['ranks'].forEach((v) {
        ranks?.add(Ranks.fromJson(v));
      });
    }
    assetsUrl = json['assets_url'];
    message = json['message'];
  }

  List<Ranks>? ranks;
  String? assetsUrl;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (ranks != null) {
      map['ranks'] = ranks?.map((v) => v.toJson()).toList();
    }
    map['assets_url'] = assetsUrl;
    map['message'] = message;
    return map;
  }
}

class Ranks {
  Ranks({
    this.id,
    this.seasonId,
    this.athleteId,
    this.divisionId,
    this.weightClassId,
    this.rank,
    this.divisionType,
    this.createdAt,
    this.updatedAt,
    this.weightClass,
    this.division,
    this.style,
  });

  Ranks.fromJson(dynamic json) {
    id = json['_id'];
    athleteId = json['athlete_id'];
    divisionType = json['division_type'];
    style = json['style'];
    divisionId = json['division_id'];
    weightClassId = json['weight_class_id'];
    seasonId = json['season_id'];
    rank = json['rank'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    weightClass = json['weight_class'] != null
        ? WeightClass.fromJson(json['weight_class'])
        : null;
    division =
        json['division'] != null ? Division.fromJson(json['division']) : null;
  }

  String? id;
  String? athleteId;
  String? divisionType;
  String? style;
  String? divisionId;
  String? weightClassId;
  String? seasonId;
  num? rank;
  String? createdAt;
  String? updatedAt;
  WeightClass? weightClass;
  Division? division;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['athlete_id'] = athleteId;
    map['division_type'] = divisionType;
    map['style'] = style;
    map['division_id'] = divisionId;
    map['weight_class_id'] = weightClassId;
    map['season_id'] = seasonId;
    map['rank'] = rank;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (weightClass != null) {
      map['weight_class'] = weightClass?.toJson();
    }
    if (division != null) {
      map['division'] = division?.toJson();
    }
    return map;
  }
}




