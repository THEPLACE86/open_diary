class ProFile {
  ProFile({
    required this.id,
    required this.content,
  });

  final int id;
  final String content;

  ProFile.fromMap({
    required Map<String, dynamic> map,
  }) :
      id = map['id'],
      content = map['content'];
}