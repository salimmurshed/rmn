class ChatEventListResponse {
  ChatEventListResponse({
      this.status, 
      this.responseData,});

  ChatEventListResponse.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? ChatEventListResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  ChatEventListResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class ChatEventListResponseData {
  ChatEventListResponseData({
    this.message,
    this.data,
    this.assetsUrl,
  });

  ChatEventListResponseData.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(EventListEventData.fromJson(v));
      });
    }
    assetsUrl = json['assets_url'];
  }

  String? message;
  List<EventListEventData>? data;
  String? assetsUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['assets_url'] = assetsUrl;
    return map;
  }

  /// ✅ Added `copyWith` method
  ChatEventListResponseData copyWith({
    String? message,
    List<EventListEventData>? data,
    String? assetsUrl,
  }) {
    return ChatEventListResponseData(
      message: message ?? this.message,
      data: data ?? this.data,
      assetsUrl: assetsUrl ?? this.assetsUrl,
    );
  }
}

class EventListEventData {
  EventListEventData({
    this.messageTime,
    this.id,
    this.coverImage,
    this.endDatetime,
    this.startDatetime,
    this.title,
    this.unreadCount,
    this.totalChats,
  });

  EventListEventData.fromJson(dynamic json) {
    messageTime = json['message_time'];
    id = json['_id'];
    coverImage = json['cover_image'];
    endDatetime = json['end_datetime'];
    startDatetime = json['start_datetime'];
    title = json['title'];
    unreadCount = json['unread_count'];
    totalChats = json['total_chats'];
  }

  String? messageTime;
  String? id;
  String? coverImage;
  String? endDatetime;
  String? startDatetime;
  String? title;
  num? unreadCount;
  num? totalChats;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message_time'] = messageTime;
    map['_id'] = id;
    map['cover_image'] = coverImage;
    map['end_datetime'] = endDatetime;
    map['start_datetime'] = startDatetime;
    map['title'] = title;
    map['unread_count'] = unreadCount;
    map['total_chats'] = totalChats;
    return map;
  }

  /// ✅ Add this `copyWith` method
  EventListEventData copyWith({
    String? messageTime,
    String? id,
    String? coverImage,
    String? endDatetime,
    String? startDatetime,
    String? title,
    num? unreadCount,
    num? totalChats,
  }) {
    return EventListEventData(
      messageTime: messageTime ?? this.messageTime,
      id: id ?? this.id,
      coverImage: coverImage ?? this.coverImage,
      endDatetime: endDatetime ?? this.endDatetime,
      startDatetime: startDatetime ?? this.startDatetime,
      title: title ?? this.title,
      unreadCount: unreadCount ?? this.unreadCount,
      totalChats: totalChats ?? this.totalChats,
    );
  }
}