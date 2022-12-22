class DiaryModel {
  DiaryModel({
    required this.id,
    required this.content,
    required this.author,
    required this.location,
    required this.lat,
    required this.lng,
    required this.feel,
    required this.images,
    required this.openDiary,
    required this.hit,
    required this.createAt,
  });

  final int id;
  final String content;
  final String author;
  final String location;
  final String feel;
  final double lat;
  final double lng;
  final List images;
  final bool openDiary;
  final int hit;
  final String createAt;

  factory DiaryModel.fromJson(Map<String, dynamic> json) =>
    DiaryModel(
      id: json['id'],
      content: json['content'],
      author: json['author'],
        location:  json['location'],
        lat: json['lat'],
        lng: json['lng'],
        feel: json['feel'],
        images: json['images'],
        openDiary: json['open_diary'],
        hit: json['hit'],
        createAt: json['create_at']
    );
}