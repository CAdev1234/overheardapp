class UserModel {
  int? id;
  String? name;
  String? firstname;
  String? lastname;
  String? email;
  String? firebaseUID;
  String? avatar;
  String? bio;
  String? phonenumber;
  int? isReporter;
  int? community_id;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.firstname,
    this.lastname,
    this.email,
    this.firebaseUID,
    this.avatar,
    this.bio,
    this.phonenumber,
    this.isReporter,
    this.community_id,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    firebaseUID = json['firebaseUID'];
    avatar = json['avatar'];
    bio = json['bio'];
    phonenumber = json['phonenumber'];
    isReporter = json['isReporter'];
    community_id = json['community_id'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['firebaseUID'] = firebaseUID;
    data['avatar'] = avatar;
    data['bio'] = bio;
    data['phonenumber'] = phonenumber;
    data['isReporter'] = isReporter;
    data['community_id'] = community_id;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}