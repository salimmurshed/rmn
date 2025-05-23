import '../../../imports/common.dart';

class ChatResponseModel {
  ChatResponseModel({
      this.status, 
      this.responseData,});

  ChatResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? ChatResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  ChatResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class ChatResponseData {
  ChatResponseData({
      this.message, 
      this.chats,});

  ChatResponseData.fromJson(dynamic json) {
    message = json['message'];
    if (json['chats'] != null) {
      chats = [];
      json['chats'].forEach((v) {
        chats?.add(Chats.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Chats.fromJson(v));
      });
    }
  }
  String? message;
  List<Chats>? chats;
  List<Chats>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (chats != null) {
      map['chats'] = chats?.map((v) => v.toJson()).toList();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Chats {
  Chats({
      this.id, 
      this.senderId, 
      this.receiverId, 
      this.eventId, 
      this.status, 
      this.roomId, 
      this.message, 
      this.showTime,
      this.dateTimeForGroupingChat,
      this.chatMessageType,
      this.chatTimeInAgoFormat,
      this.createdAt,this.isNewChat});

  Chats.fromJson(dynamic json) {
    id = json['_id'];
    senderId = json['sender_id'];
    showTime = json['showTime'];
    receiverId = json['receiver_id'];
    eventId = json['event_id'];
    status = json['status'];
    roomId = json['room_id'];
    message = json['message'];
    createdAt = json['createdAt'];
    dateTimeForGroupingChat = json['dateTimeForGroupingChat'];
    chatMessageType = json['chatMessageType'];
    chatTimeInAgoFormat = json['chatTimeInAgoFormat'];
    isNewChat = json['is_new_chat'];
  }
  String? id;
  String? senderId;
  String? receiverId;
  String? eventId;
  String? status;
  String? roomId;
  String? message;
  bool? showTime;
  bool? isNewChat;
  String? createdAt;
  String? chatTimeInAgoFormat;
  String? dateTimeForGroupingChat;
  ChatMessageType?chatMessageType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['showTime'] = showTime;
    map['sender_id'] = senderId;
    map['receiver_id'] = receiverId;
    map['event_id'] = eventId;
    map['status'] = status;
    map['room_id'] = roomId;
    map['message'] = message;
    map['createdAt'] = createdAt;
    map['chatTimeInAgoFormat'] = chatTimeInAgoFormat;
    map['chatMessageType'] = chatMessageType;
    map['dateTimeForGroupingChat'] = dateTimeForGroupingChat;
    map['is_new_chat'] = isNewChat;
    return map;
  }

}