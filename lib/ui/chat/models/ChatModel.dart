import 'package:overheard/ui/chat/models/ChatMessageModel.dart';

class ChatModel {
  late int interlocutorId;
  late bool isBlocked;
  late ChatMessageModel lastMsg;

  ChatModel({required this.interlocutorId, required this.isBlocked, required this.lastMsg});


  ChatModel.fromJson(Map<String, dynamic> json) {
    interlocutorId = json['interlocutorId'];
    isBlocked = json['isBlocked'];
    lastMsg = json['lastMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['interlocutorId'] = interlocutorId;
    data['isBlocked'] = isBlocked;
    data['lastMsg'] = lastMsg;
    // data['participants'] = participants;
    // data['radius'] = radius;
    // data['ads_price'] = adsPrice;
    // data['created_at'] = createdAt;
    return data;
  }
}

ChatMessageModel lastMsg = ChatMessageModel(
  userId: 1,
  interlocutorId: 1,
  text: "Hey, Jillian. Both of the above options do query database on each request! Both of the above options do query database on each request!",
  messageType: ChatMessageType.video,
  messageStatus: MessageStatus.notView,
  messageActionStatus: MessageActionStatus.none,
  isMine: false,
  createdAt: '04:15 PM'
);

List<ChatModel> chatListSample = [
  ChatModel(interlocutorId: 0, lastMsg: lastMsg, isBlocked: false),
  ChatModel(interlocutorId: 1, lastMsg: lastMsg, isBlocked: false),
  ChatModel(interlocutorId: 2, lastMsg: lastMsg, isBlocked: true),
  ChatModel(interlocutorId: 3, lastMsg: lastMsg, isBlocked: false),
  ChatModel(interlocutorId: 4, lastMsg: lastMsg, isBlocked: true),
  ChatModel(interlocutorId: 5, lastMsg: lastMsg, isBlocked: false),
  ChatModel(interlocutorId: 6, lastMsg: lastMsg, isBlocked: false),
  ChatModel(interlocutorId: 7, lastMsg: lastMsg, isBlocked: true),
  ChatModel(interlocutorId: 8, lastMsg: lastMsg, isBlocked: false),
  ChatModel(interlocutorId: 9, lastMsg: lastMsg, isBlocked: false),
  ChatModel(interlocutorId: 10, lastMsg: lastMsg, isBlocked: false),
  ChatModel(interlocutorId: 11, lastMsg: lastMsg, isBlocked: false),
];