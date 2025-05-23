import '../../../imports/data.dart';

class AwardsResponseModel {
  AwardsResponseModel({
    this.status,
    this.responseData,
  });

  AwardsResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? AwardsResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  AwardsResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class AwardsResponseData {
  AwardsResponseData({
    this.awards,
    this.assetsUrl,
    this.message,
    this.lastUpdate,
  });

  AwardsResponseData.fromJson(dynamic json) {
    if (json['awards'] != null) {
      awards = [];
      json['awards'].forEach((v) {
        awards?.add(Awards.fromJson(v));
      });
    }
    assetsUrl = json['assets_url'];
    message = json['message'];
    lastUpdate = json['last_update'] != null
        ? LastUpdate.fromJson(json['last_update'])
        : null;
  }

  List<Awards>? awards;
  String? assetsUrl;
  String? message;
  LastUpdate? lastUpdate;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (awards != null) {
      map['awards'] = awards?.map((v) => v.toJson()).toList();
    }
    map['assets_url'] = assetsUrl;
    map['message'] = message;
    if (lastUpdate != null) {
      map['last_update'] = lastUpdate?.toJson();
    }
    return map;
  }
}

class Awards {
  Awards({
    this.id,
    this.status,
    this.athleteId,
    this.criteria,
    this.award,
    this.division,
    this.weightClass,
  });

  Awards.fromJson(dynamic json) {
    id = json['_id'];
    status = json['status'];
    athleteId = json['athlete_id'];
    criteria =
        json['criteria'] != null ? (json['criteria'] as List).map((i) => Criteria.fromJson(i)).toList() : [];
    award = json['award'] != null ? Award.fromJson(json['award']) : null;
    division =
        json['division'] != null ? Division.fromJson(json['division']) : null;
    weightClass = json['weight_class'] != null
        ? WeightClass.fromJson(json['weight_class'])
        : null;
  }

  String? id;
  String? status;
  String? athleteId;
  List<Criteria>? criteria;
  Award? award;
  Division? division;
  WeightClass? weightClass;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['status'] = status;
    map['athlete_id'] = athleteId;
    if (criteria != null) {
      map['criteria'] = criteria?.map((v) => v.toJson()).toList();
    }
    if (award != null) {
      map['award'] = award?.toJson();
    }
    if (division != null) {
      map['division'] = division?.toJson();
    }
    if (weightClass != null) {
      map['weight_class'] = weightClass?.toJson();
    }
    return map;
  }
}





class Award {
  Award({
    this.description,
    this.id,
    this.title,
    this.image,
  });

  Award.fromJson(dynamic json) {
    description = json['description'];
    id = json['_id'];
    title = json['title'];
    image = json['image'];
  }

  String? description;
  String? id;
  String? title;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['_id'] = id;
    map['title'] = title;
    map['image'] = image;
    return map;
  }
}

class Criteria {
  Criteria({
    this.winSpecificEvents,
    this.athleteWinSpecificEvents,
    this.minEvents,
    this.athleteWinEvents,
    this.athleteMatches,
    this.totalMatches,
    this.totalPecentage,
    this.criteriaProgress,
    this.totalPercentage,
    this.target, this.achieved, this.progress, this.text
  });

  Criteria.fromJson(dynamic json) {
    winSpecificEvents = json['win_specific_events'] != null
        ? json['win_specific_events'].cast<String>()
        : [];
    athleteWinSpecificEvents = json['athlete_win_specific_events'];
    minEvents = json['min_events'];
    athleteWinEvents = json['athlete_win_events'];
    athleteMatches = json['athlete_matches'];
    totalMatches = json['total_matches'];
    totalPecentage = json['total_pecentage'];
    criteriaProgress = json['criteria_progress'] != null
        ? json['criteria_progress'].cast<num>()
        : [];
    totalPercentage = json['total_percentage'];
    target = json['target'];
    achieved = json['achieved'];
    progress = json['progress'];
    text = json['text'];
  }

  List<String>? winSpecificEvents;
  num? athleteWinSpecificEvents;
  num? minEvents;
  num? athleteWinEvents;
  num? athleteMatches;
  num? totalMatches;
  num? totalPecentage;
  List<num>? criteriaProgress;
  num? totalPercentage;
  int? target;
  int? achieved;
  int? progress;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['win_specific_events'] = winSpecificEvents;
    map['athlete_win_specific_events'] = athleteWinSpecificEvents;
    map['min_events'] = minEvents;
    map['athlete_win_events'] = athleteWinEvents;
    map['athlete_matches'] = athleteMatches;
    map['total_matches'] = totalMatches;
    map['total_pecentage'] = totalPecentage;
    map['criteria_progress'] = criteriaProgress;
    map['total_percentage'] = totalPercentage;
    map['target'] = target;
    map['achieved'] = achieved;
    map['progress'] = progress;
    map['text'] = text;
    return map;
  }
}

class LastUpdate {
  EventData? event;
  String? updatedAt;

  LastUpdate({this.event, this.updatedAt});

  LastUpdate.fromJson(Map<String, dynamic> json) {
    event = json['event'] != null ? EventData.fromJson(json['event']) : null;
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (event != null) {
      data['event'] = event!.toJson();
    }
    data['updated_at'] = updatedAt;
    return data;
  }
}