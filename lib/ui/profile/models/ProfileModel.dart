class ProfileModel {
  String? name;
  String? firstname;
  String? lastname;
  String? avatar;
  String? bio;
  int? communityId;
  int? isActive;
  int? isVerified;
  Community? community;
  int? totalPost;
  bool? isBlocked;
  bool? isFollowing;

  ProfileModel(
      {this.name,
        this.firstname,
        this.lastname,
        this.avatar,
        this.bio,
        this.communityId,
        this.isActive,
        this.isVerified,
        this.community,
        this.totalPost,
        this.isBlocked,
        this.isFollowing});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    avatar = json['avatar'];
    bio = json['bio'];
    communityId = json['community_id'];
    isActive = json['isActive'];
    isVerified = json['isVerified'];
    community = json['community'] != null
        ? Community.fromJson(json['community'])
        : null;
    totalPost = json['totalPost'];
    isBlocked = json['isBlocked'];
    isFollowing = json['isFollowing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['avatar'] = avatar;
    data['bio'] = bio;
    data['community_id'] = communityId;
    data['isActive'] = isActive;
    data['isVerified'] = isVerified;
    if (community != null) {
      data['community'] = community!.toJson();
    }
    data['totalPost'] = totalPost;
    data['isBlocked'] = isBlocked;
    data['isFollowing'] = isFollowing;
    return data;
  }
}

class Community {
  int? id;
  String? name;
  String? zipCode;
  int? participants;
  String? radius;
  String? adsPrice;
  String? createdAt;

  Community(
      {this.id,
        this.name,
        this.zipCode,
        this.participants,
        this.radius,
        this.adsPrice,
        this.createdAt});

  Community.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    zipCode = json['zip_code'];
    participants = json['participants'];
    radius = json['radius'];
    adsPrice = json['ads_price'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['zip_code'] = zipCode;
    data['participants'] = participants;
    data['radius'] = radius;
    data['ads_price'] = adsPrice;
    data['created_at'] = createdAt;
    return data;
  }
}