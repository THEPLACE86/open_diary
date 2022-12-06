class DiaryModel {
  DiaryModel({
    required this.id,
    required this.content,
    required this.author,
    required this.location,
    required this.lat,
    required this.lng,
  });

  final int id;
  final String content;
  final String author;
  final String location;
  final double lat;
  final double lng;

  DiaryModel.fromMap({
    required Map<String, dynamic> map,
  }) :
      id = map['id'],
      content = map['content'],
      location = map['location'],
      lat = map['lat'],
      lng = map['lng'],
      author = map['author'];
}