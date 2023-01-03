class CommentModel {
  CommentModel({
    required this.id,
    required this.nickname,
    required this.comment,
    required this.createdAt,
    required this.author,
    required this.diaryId,
  });

  final int id;
  final String nickname;
  final String comment;
  final DateTime createdAt;
  final String author;
  final int diaryId;

  CommentModel.fromMap({
    required Map<String, dynamic> map
  })  : id = map['id'],
        nickname = map['nickname'],
        comment = map['comment'],
        diaryId = map['diary_id'],
        author = map['author'],
        createdAt = DateTime.parse(map['created_at']);
}