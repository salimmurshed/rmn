import '../../../imports/data.dart';

class ReceivedChatResponseModel {
   Chats? messageData;
   ReceivedChatResponseModel({ this.messageData});
  factory ReceivedChatResponseModel.fromJson(Map<String, dynamic> json) =>
      ReceivedChatResponseModel(
        messageData: json['messageData'] == null
            ? null
            : Chats.fromJson(json['messageData'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    'messageData': messageData,
  };
}