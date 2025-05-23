import 'package:rmnevents/common/resources/app_enums.dart';

class ChatListRequestModel {
  final int page;
  final ChatType type;
  final String? eventId;
  ChatListRequestModel(
      {required this.page,
        required this.type, this.eventId});
}