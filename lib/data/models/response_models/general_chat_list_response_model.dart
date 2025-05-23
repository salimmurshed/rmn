class GeneralChatListResponseModel {
  GeneralChatListResponseModel({
      this.status, 
      this.generalListresponseData,});

  GeneralChatListResponseModel.fromJson(dynamic json) {
    status = json['status'];
    generalListresponseData = json['responseData'] != null ? GeneralListresponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  GeneralListresponseData? generalListresponseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (generalListresponseData != null) {
      map['responseData'] = generalListresponseData?.toJson();
    }
    return map;
  }

}

class GeneralListresponseData {
  GeneralListresponseData({
      this.total, 
      this.page, 
      this.perPage, 
      this.totalPage, 
      this.assetsUrl, 
      this.generalChatData, 
      this.message,});

  GeneralListresponseData.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    perPage = json['per_page'];
    totalPage = json['total_page'];
    assetsUrl = json['assets_url'];
    if (json['data'] != null) {
      generalChatData = [];
      json['data'].forEach((v) {
        generalChatData?.add(GeneralChatData.fromJson(v));
      });
    }
    eventData =  json['event'] != null ? EventData.fromJson(json['event']) : null;
    message = json['message'];
  }
  num? total;
  num? page;
  num? perPage;
  num? totalPage;
  String? assetsUrl;
  List<GeneralChatData>? generalChatData;
  String? message;
  EventData? eventData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['per_page'] = perPage;
    map['total_page'] = totalPage;
    map['assets_url'] = assetsUrl;
    if (generalChatData != null) {
      map['data'] = generalChatData?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    map['event'] = eventData;
    return map;
  }

}

class GeneralChatData {
  GeneralChatData({
      this.id, 
      this.messageTime, 
      this.lastMessage, 
      this.roomId, 
      this.status, 
      this.unreadCount, 
      this.senderId, 
      this.user,});

  GeneralChatData.fromJson(dynamic json) {
    id = json['_id'];
    messageTime = json['message_time'];
    lastMessage = json['last_message'];
    roomId = json['room_id'];
    status = json['status'];
    unreadCount = json['unread_count'];
    senderId = json['sender_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? id;
  String? messageTime;
  String? lastMessage;
  String? roomId;
  String? status;
  num? unreadCount;
  String? senderId;
  User? user;
  int? index;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['message_time'] = messageTime;
    map['last_message'] = lastMessage;
    map['room_id'] = roomId;
    map['status'] = status;
    map['unread_count'] = unreadCount;
    map['sender_id'] = senderId;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

class User {
  User({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.profile,});

  User.fromJson(dynamic json) {
    id = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profile = json['profile'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? profile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['profile'] = profile;
    return map;
  }

}

class EventData{
  EventData({
    this.id,
    this.title,
    this.coverImage,
    this.startDateTime,
    this.address,
    this.timeZone
  });
  EventData.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    coverImage = json['cover_image'];
    startDateTime = json['start_datetime'];
    address = json['address'];
    timeZone = json['timezone'];
  }
  String? id;
  String? title;
  String? coverImage;
  String? startDateTime;
  String? address;
  String? timeZone;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['title'] = title;
    map['cover_image'] = coverImage;
    map['start_datetime'] = startDateTime;
    map['address'] = address;
    map['timezone'] = timeZone;
    return map;
  }
}