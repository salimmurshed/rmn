class NotificationResponseModel {
  NotificationResponseModel({
      this.status, 
      this.responseData,});

  NotificationResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? NotificationResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  NotificationResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class AddtionalData {
  AddtionalData({
    this.chatRoomId,});

  AddtionalData.fromJson(dynamic json) {
    chatRoomId = json['chat_room_id'];
  }
  String? chatRoomId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['chat_room_id'] = chatRoomId;
    return map;
  }

}

class NotificationResponseData {
  NotificationResponseData({
      this.notifications, 
      this.message,});

  NotificationResponseData.fromJson(dynamic json) {
    if (json['notifications'] != null) {
      notifications = [];
      json['notifications'].forEach((v) {
        notifications?.add(Notifications.fromJson(v));
      });
    }
    message = json['message'];
  }
  List<Notifications>? notifications;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (notifications != null) {
      map['notifications'] = notifications?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }

}

class Notifications {
  Notifications({
      this.id, 
      this.title, 
      this.refId, 
      this.keyword, 
      this.message, 
      this.notificationType, 
      this.keywordValue, 
      this.createdAt, 
      this.addtionalData,
      this.isRead,});

  Notifications.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    refId = json['ref_id'];
    keyword = json['keyword'];
    message = json['message'];
    notificationType = json['notification_type'];
    keywordValue = json['keyword_value'];
    createdAt = json['createdAt'];
    isRead = json['is_read'];
    addtionalData = json['addtional_data'] != null ? AddtionalData.fromJson(json['addtional_data']) : null;
  }
  String? id;
  String? title;
  String? refId;
  String? keyword;
  String? message;
  String? notificationType;
  String? keywordValue;
  String? createdAt;
  bool? isRead;
  AddtionalData? addtionalData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['title'] = title;
    map['ref_id'] = refId;
    map['keyword'] = keyword;
    map['message'] = message;
    map['notification_type'] = notificationType;
    map['keyword_value'] = keywordValue;
    map['createdAt'] = createdAt;
    map['addtional_data'] = addtionalData?.toJson();
    map['is_read'] = isRead;
    return map;
  }

}