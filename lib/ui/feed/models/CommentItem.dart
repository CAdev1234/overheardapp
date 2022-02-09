class CommentModel {
  Comment? comment;
  List<CommentUser>? commentUser;

  CommentModel({this.comment, this.commentUser});

  CommentModel.fromJson(Map<String, dynamic> json) {
    comment =
    json['comment'] != null ? new Comment.fromJson(json['comment']) : null;
    if (json['comment_user'] != null) {
      commentUser = [];
      json['comment_user'].forEach((v) {
        commentUser!.add(CommentUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comment != null) {
      data['comment'] = this.comment!.toJson();
    }
    if (this.commentUser != null) {
      data['comment_user'] = this.commentUser!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['commenter_id'] = this.commenterId;
    data['comment_content'] = this.commentContent;
    data['upvotes'] = this.upvotes;
    data['downvotes'] = this.downvotes;
    data['comment_datetime'] = this.commentDatetime;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['avatar'] = this.avatar;
    data['bio'] = this.bio;
    return data;
  }
}