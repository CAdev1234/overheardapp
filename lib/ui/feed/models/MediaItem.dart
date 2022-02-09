class MediaItem {
  int? id;
  int? postId;
  String? filename;
  String? url;
  String? thumbnail;

  MediaItem({this.id, this.postId, this.filename, this.url, this.thumbnail});

  MediaItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    filename = json['filename'];
    url = json['url'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['filename'] = this.filename;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}