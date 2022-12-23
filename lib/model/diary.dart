class DiaryModel {
  int? id;
  String? content;
  String? author;
  String? location;
  String? feel;
  double? lat;
  double? lng;
  List? images;
  List? tags;
  bool? openDiary;
  int? hit;
  String? createAt;
  String? nickName;

  DiaryModel.fromJson(obj) {
    id = obj['id'] ?? 0;
    content = obj['content'] ?? '';
    author = obj['author'] ?? '';
    location = obj['location'] ?? '';
    feel = obj['feel'] ?? '';
    lat = obj['lat'] ?? 123.4040;
    lng = obj['lng'] ?? 36.234;
    images = obj['images'] ?? [];
    openDiary = obj['open_diary'] ?? true;
    hit = obj['hit'] ?? 0;
    createAt = obj['create_at'] ?? '';
    nickName = obj['nickname'] ?? '';
    tags = obj['tags'] ?? [];
  }

  static List<DiaryModel> fromJsonList(jsonList) {
    return jsonList.map<DiaryModel>((obj) => DiaryModel.fromJson(obj)).toList();
  }
}