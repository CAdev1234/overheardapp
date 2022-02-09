class BlockedModel {
  int? id;
  String? name;
  String? avatar;

  BlockedModel({this.id, this.name, this.avatar});

  BlockedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    return data;
  }
}