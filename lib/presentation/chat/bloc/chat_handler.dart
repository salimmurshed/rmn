import 'package:intl/intl.dart';
import 'package:rmnevents/common/resources/app_enums.dart';

import '../../../imports/data.dart';
import 'chat_bloc.dart';

class ChatHandler {
  static List<Chats> updateChat({required List<Chats> chats, required bool isGenralChat}) {
    for (Chats chat in chats) {
       chat.showTime =true;
      DateTime createdDate = DateTime.parse(chat.createdAt!);
     chat.chatTimeInAgoFormat = convertToFigmaTime(createdDate);
         //GlobalHandlers.getHumanReadableTimeStampInAgoFormat(chat.createdAt!);
      chat.dateTimeForGroupingChat = DateFormat.yMMMd().format(createdDate);
      chat.chatMessageType = chat.receiverId == null
          ? (isGenralChat ? ChatMessageType.received : ChatMessageType.sent)
          : (isGenralChat ? ChatMessageType.sent : ChatMessageType.received);
    }
    return chats;
  }
}
