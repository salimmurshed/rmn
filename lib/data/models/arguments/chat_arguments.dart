class ChatArguments {
  final String eventId;
  final String roomId;
  String recevierId;
  String? profileImage;
  bool isFromDetailView;
  bool isForGeneralChat;
  String userName;
  bool? isFromPush;
   ChatArguments({required this.eventId, required this.roomId, this.isFromDetailView = true,this.isForGeneralChat = false, this.userName = '', this.recevierId = '', this.profileImage, this.isFromPush = false});
}
