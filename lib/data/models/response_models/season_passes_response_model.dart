class SeasonPassesResponseModel {
  SeasonPassesResponseModel({
    this.status,
    this.responseData,
  });

  SeasonPassesResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? SeasonPassesResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  SeasonPassesResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class SeasonPassesResponseData {
  SeasonPassesResponseData({
    this.data,
    this.message,
  });

  SeasonPassesResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SeasonPass.fromJson(v));
      });
    }
    message = json['message'];
  }

  List<SeasonPass>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }
}

class SeasonPass {
  SeasonPass({
    this.description,
    this.isActive,
    this.isMembership,
    this.isGiveaway,
    this.image,
    this.variants,
    this.softDelete,
    this.id,
    this.title,
    this.price,
    this.seasonId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.endDate,
    this.startDate,
    this.underscoreId,
  });

  SeasonPass.fromJson(dynamic json) {
    description = json['description'];
    underscoreId = json['_id'];
    endDate = json['end_date'];
    startDate = json['start_date'];
    isActive = json['is_active'];
    isMembership = json['is_membership'];
    isGiveaway = json['is_giveaway'];
    image = json['image'];
    if (json['variants'] != null) {
      variants = [];
      json['variants'].forEach((v) {
        variants?.add(v);
      });
    }
    softDelete = json['soft_delete'];
    id = json['_id'];
    title = json['title'];
    price = json['price'];
    seasonId = json['season_id'];
    content = json['content'] != null ? json['content'].cast<String>() : [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  String? description;
  bool? isActive;
  bool? isMembership;
  bool? isGiveaway;
  dynamic image;
  List<String>? variants;
  num? softDelete;
  String? id;
  String? title;
  num? price;
  String? seasonId;
  List<String>? content;
  String? createdAt;
  String? updatedAt;
  String? endDate;
  String? startDate;
  String? underscoreId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['is_active'] = isActive;
    map['is_membership'] = isMembership;
    map['is_giveaway'] = isGiveaway;
    map['image'] = image;
    if (variants != null) {
      map['variants'] = variants;
    }
    map['soft_delete'] = softDelete;
    map['_id'] = id;
    map['title'] = title;
    map['price'] = price;
    map['season_id'] = seasonId;
    map['content'] = content;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['underscoreId'] = underscoreId;
    return map;
  }
}
