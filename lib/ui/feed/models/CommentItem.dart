class CommentModel {
  Comment? comment;
  List<CommentUser>? commentUser;

  CommentModel({this.comment, this.commentUser});

  CommentModel.fromJson(Map<String, dynamic> json) {
    comment =
    json['comment'] != null ? Comment.fromJson(json['comment']) : null;
    if (json['comment_user'] != null) {
      commentUser = [];
      json['comment_user'].forEach((v) {
        commentUser!.add(CommentUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (comment != null) {
      data['comment'] = comment!.toJson();
    }
    if (commentUser != null) {
      data['comment_user'] = commentUser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  int? id;
  int? postId;
  int? commenterId;
  String? commentContent;
  int? upvotes;
  int? downvotes;
  String? commentDatetime;

  Comment(
      {this.id,
        this.postId,
        this.commenterId,
        this.commentContent,
        this.upvotes,
        this.downvotes,
        this.commentDatetime});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    commenterId = json['commenter_id'];
    commentContent = json['comment_content'];
    upvotes = json['upvotes'];
    downvotes = json['downvotes'];
    commentDatetime = json['comment_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['post_id'] = postId;
    data['commenter_id'] = commenterId;
    data['comment_content'] = commentContent;
    data['upvotes'] = upvotes;
    data['downvotes'] = downvotes;
    data['comment_datetime'] = commentDatetime;
    return data;
  }
}

class CommentUser {
  int? id;
  String? name;
  String? firstname;
  String? lastname;
  String? avatar;
  String? bio;

  CommentUser({
    this.id,
    this.name,
    this.firstname,
    this.lastname,
    this.avatar,
    this.bio});

  CommentUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    avatar = json['avatar'];
    bio = json['bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['avatar'] = avatar;
    data['bio'] = bio;
    return data;
  }
}