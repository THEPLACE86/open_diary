class DiaryModel {
  DiaryModel({
    required this.id,
    required this.content,
    required this.author
  });

  final int id;
  final String content;
  final String author;

  DiaryModel.fromMap({
    required Map<String, dynamic> map,
  }) :
      id = map['id'],
      content = map['content'],
      author = map['author'];
}