class TagItem {
  String? tag;

  TagItem({this.tag});

  TagItem.fromJson(Map<String, dynamic> json) {
    tag = json['tag'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['tag'] = tag;
    return data;
  }
}