import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/feed/models/CommentItem.dart';
import 'package:overheard_flutter_app/ui/feed/models/MediaItem.dart';
import 'package:overheard_flutter_app/ui/feed/models/TagItem.dart';

class FeedModel {
  int? id;
  int? userId;
  String? content;
  String? title;
  String? location;
  double? lat;
  double? lng;
  int? upvotes;
  int? downvotes;
  int? seenCount;
  int? commentsCount;
  String? postDatetime;
  List<MediaItem> media = [];
  UserModel? publisher;
  List<TagItem> tags = [];
  List<CommentModel> comments = [];

  FeedModel(
      {this.id,
        this.userId,
        this.content,
        this.title,
        this.location,
        this.lat,
        this.lng,
        this.upvotes,
        this.downvotes,
        this.seenCount,
        this.commentsCount,
        this.postDatetime,
        required this.media,
        this.publisher,
        required this.tags,
        required this.comments
      });

  FeedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    content = json['content'];
    title = json['title'];
    location = json['location'];
    lat = json['lat'];
    lng = json['lng'];
    upvotes = json['upvotes'];
    downvotes = json['downvotes'];
    seenCount = json['seen_count'];
    commentsCount = json['comments_count'];
    postDatetime = json['post_datetime'];

    if (json['media'] != null) {
      media = [];
      json['media'].forEach((v) {
        media.add(MediaItem.fromJson(v));
      });
    }
    publisher = json['publisher'] != null
        ? UserModel.fromJson(json['publisher'])
        : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags.add(TagItem.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments.add(CommentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user_id'] = userId;
    data['content'] = content;
    data['upvotes'] = upvotes;
    data['downvotes'] = downvotes;
    data['seen_count'] = seenCount;
    data['comments_count'] = commentsCount;
    data['post_datetime'] = postDatetime;
    if (media != null) {
      data['media'] = media.map((v) => v.toJson()).toList();
    }
    if (publisher != null) {
      data['publisher'] = publisher?.toJson();
    }
    if (tags != null) {
      data['tags'] = tags.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      data['comments'] = comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}