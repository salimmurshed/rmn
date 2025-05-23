class AdminAvialibilityResponseModel {
  AdminAvialibilityResponseModel({
      this.isOnline,});

  AdminAvialibilityResponseModel.fromJson(dynamic json) {
    isOnline = json['is_online'];
  }
  bool? isOnline;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_online'] = isOnline;
    return map;
  }

}