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
  List? like;
  bool? openDiary;
  int? hit;
  int? commentCount;
  String? createAt;
  String? nickName;
  String? createDate;

  DiaryModel.fromJson(obj) {
    id = obj['id'] ?? 0;
    content = obj['content'] ?? '';
    author = obj['author'] ?? '';
    location = obj['location'] ?? '';
    feel = obj['feel'] ?? '';
    lat = obj['lat'] ?? 37.2042;
    lng = obj['lng'] ?? 126.864;
    images = obj['images'] ?? [];
    openDiary = obj['open_diary'] ?? true;
    hit = obj['hit'] ?? 0;
    commentCount = obj['comment_count'] ?? 0;
    createAt = obj['create_at'] ?? '';
    nickName = obj['nickname'] ?? '';
    tags = obj['tags'] ?? [];
    like = obj['like'] ?? [];
    createDate = obj['create_date'] ?? '';
  }

  static List<DiaryModel> fromJsonList(jsonList) {
    return jsonList.map<DiaryModel>((obj) => DiaryModel.fromJson(obj)).toList();
  }
}