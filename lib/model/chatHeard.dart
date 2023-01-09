class ChatHeardModel {
  ChatHeardModel({
    required this.id,
    required this.createUser,
    required this.title,
    required this.userList,
    required this.maxUser,
    required this.createdAt,
    required this.createNickName,
  });

  final int id;
  final String createUser;
  final String title;
  final DateTime createdAt;
  final String createNickName;
  final List userList;
  final int maxUser;

  ChatHeardModel.fromMap({
    required Map<String, dynamic> map
  })  : id = map['id'],
      createUser = map['create_user'],
      title = map['title'],
      userList = map['user_list'] ?? [],
      createNickName = map['create_nickname'],
      maxUser = map['max_user'],
      createdAt = DateTime.parse(map['created_at']);
}