
enum ChatMessageType { text, audio, image, video }
enum MessageStatus { notSent, pending, sent, notView, viewed, deleted }
enum MessageActionStatus { none, copied, marked, replied, forwarded, deleted }

class ChatMessageModel {
  int userId;
  String text;
  int interlocutorId;
  ChatMessageType messageType;
  MessageStatus messageStatus;
  MessageActionStatus messageActionStatus;
  bool isMine;
  String createdAt;

  ChatMessageModel({
    required this.userId,
    required this.interlocutorId,
    required this.text,
    required this.messageType,
    required this.messageStatus,
    required this.messageActionStatus,
    required this.isMine,
    required this.createdAt
  });

  void setText(String text) {
    this.text = text;
  }
  
}


List<ChatMessageModel> demoChatMessage = [
  ChatMessageModel(
    userId: 0,
    interlocutorId: 1,
    text: "Hello John",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.sent,
    messageActionStatus: MessageActionStatus.none,
    isMine: true,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 1,
    interlocutorId: 1,
    text: "Hey, Jillian",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.pending,
    messageActionStatus: MessageActionStatus.none,
    isMine: false,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 2,
    interlocutorId: 1,
    text: "I'm doing great, thanks",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.notSent,
    messageActionStatus: MessageActionStatus.none,
    isMine: false,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 3,
    interlocutorId: 1,
    text: "I'm doing good, thank you",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.notSent,
    messageActionStatus: MessageActionStatus.none,
    isMine: true,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 4,
    interlocutorId: 1,
    text: "Far from the countries Vokalia and Consonantia, there live the blind texts",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    messageActionStatus: MessageActionStatus.none,
    isMine: true,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 5,
    interlocutorId: 1,
    text: "Hey, Jillian",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    messageActionStatus: MessageActionStatus.none,
    isMine: false,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 6,
    interlocutorId: 1,
    text: "I'm doing great, thanks",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    messageActionStatus: MessageActionStatus.none,
    isMine: false,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 7,
    interlocutorId: 1,
    text: "Hey, Jillian",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.sent,
    messageActionStatus: MessageActionStatus.none,
    isMine: false,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 8,
    interlocutorId: 1,
    text: "I'm doing great, thanks",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    messageActionStatus: MessageActionStatus.none,
    isMine: false,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 9,
    interlocutorId: 1,
    text: "I'm doing good, thank you",
    messageType: ChatMessageType.audio,
    messageStatus: MessageStatus.deleted,
    messageActionStatus: MessageActionStatus.none,
    isMine: true,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 10,
    interlocutorId: 1,
    text: "Lorem ipsum dolor sit amet.",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    messageActionStatus: MessageActionStatus.none,
    isMine: true,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 11,
    interlocutorId: 1,
    text: "I'm doing good, thank you",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.deleted,
    messageActionStatus: MessageActionStatus.none,
    isMine: true,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 12,
    interlocutorId: 1,
    text: "Lorem ipsum dolor sit amet.",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    messageActionStatus: MessageActionStatus.none,
    isMine: true,
    createdAt: '04:15 PM'
  ),
  ChatMessageModel(
    userId: 12,
    interlocutorId: 1,
    text: "",
    messageType: ChatMessageType.image,
    messageStatus: MessageStatus.viewed,
    messageActionStatus: MessageActionStatus.none,
    isMine: true,
    createdAt: '04:15 PM'
  ),
];