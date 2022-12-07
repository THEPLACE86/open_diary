class DiaryModel {
  DiaryModel({
    required this.id,
    required this.content,
    required this.author,
    required this.location,
    required this.lat,
    required this.lng,
    required this.feel,
  });

  final int id;
  final String content;
  final String author;
  final String location;
  final String feel;
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
      feel = map['feel'],
      author = map['author'];
}