class PostModel {
  String? content;

  PostModel.fromJson(obj) {
    content = obj['content'];
  }

  static List<PostModel> fromJsonList(jsonList) {
    return jsonList.map<PostModel>((obj) => PostModel.fromJson(obj)).toList();
  }
}