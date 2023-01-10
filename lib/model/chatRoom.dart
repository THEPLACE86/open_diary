class ChatRoomModel {
  ChatRoomModel({
    required this.id,
    required this.message,
    required this.chatListId,
    required this.nickname,
    required this.createdAt,
    required this.author,
    required this.isMine,
  });

  final int id;
  final String message;
  final DateTime createdAt;
  final int chatListId;
  final String nickname;
  final String author;
  final bool isMine;

  ChatRoomModel.fromMap({
    required Map<String, dynamic> map,
    required String myUserId
  })  : id = map['id'],
      nickname = map['nickname'],
      message = map['message'],
      chatListId = map['chat_list_id'],
      author = map['author'],
      createdAt = DateTime.parse(map['created_at']),
      isMine = myUserId == map['author'];
}