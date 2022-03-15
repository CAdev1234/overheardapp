import 'package:firebase_auth/firebase_auth.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/services/restclient.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

class FacebookUserModel {
  String? email;
  String? id;
  String? name;
  FacebookPictureModel? picture;
  AccessToken? token;

  FacebookUserModel({this.email, this.id, this.name, this.picture, this.token});

  FacebookUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    name = json['name'];
    token = json['token'];
    picture = FacebookPictureModel.fromJson(json['picture']['data']);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['picture'] = picture;
    data['token'] = token;
    return data;
  }
}
class FacebookPictureModel {
  final String? url;
  final int? height;
  final int? width;

  const FacebookPictureModel({this.url, this.height, this.width});

  factory FacebookPictureModel.fromJson(Map<String, dynamic> json) => FacebookPictureModel(
    url: json['url'],
    height: json['height'],
    width: json['width']
  );

}

class AuthRepository extends RestApiClient{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FacebookLogin faceBookSignIn = FacebookLogin();

  final TwitterLogin twitterSignIn = TwitterLogin(
      apiKey: twitter_Api,
      apiSecretKey: twitter_Secret,
      // redirectURI: Platform.isAndroid ? 'overheardnet://' : 'twitterkit-D62hrgqhkxMBOhs6r6VxbmBVW://'
      redirectURI: 'overheardnet://'
  );

  Future<Map<dynamic, dynamic>?> signInWithEmail(Map<String, dynamic> credential) async {
    try{
      final result = await postData(SIGNIN_URL, credential);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
      return {};
    }
    return null;
  }

  Future<Map<dynamic, dynamic>> signInWithToken() async {
    try{
      final result = await postData(SIGNIN_WITH_TOKEN_URL, {});
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> signInWithFirebase(Map<String, dynamic> credential) async {
    try{
      final result = await postData(FIREBASE_SIGNIN_URL, credential);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      print(exception);
    }
    return {};
  }

  Future<Map?> signUpWithEmail(Map<String, dynamic> credential) async {
    try{
      final result = await postData(SIGNUP_URL, credential);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return null;
  }

  Future<Map?> emailVerify(String parameter) async {
    try{
      final result = await getData(parameter);
      if(result.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return null;
  }

  Future<Map?> emailVerifyResend(String email) async {
    try{
      final result = await getData(VERIFY_RESEND_URL + email);
      if(result.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return null;
  }

  Future<bool> signUpWithFirebase(Map<String, dynamic> credential) async {
    try{
      final result = await postData(FIREBASE_SIGNUP_URL, credential);
      if(result?.statusCode == HttpStatus.ok){
        return json.decode(result!.body)['result'];
      }
    }
    catch(exception){
      // print(exception);
    }
    return false;
  }

  Future<Map<dynamic, dynamic>?> signInWithFaceBook() async {
    final LoginResult result = await FacebookAuth.i.login();
    if (result.status == LoginStatus.success) {
      AccessToken? token = result.accessToken;
      // final userData = await FacebookAuth.instance.getUserData();
      // FacebookUserModel fbuser = FacebookUserModel.fromJson(userData);
      User? user = await _signInWithFacebook(token!.token);
      Map profile = {};
      if (user == null) {
        return null;
      }
      profile['userid'] = user.uid;
      profile['token'] = await user.getIdToken();
      profile['email'] = user.email;
      profile['name'] = user.displayName;
      profile['profile_image_url'] = user.photoURL;
      return profile;
    }else if (result.status == LoginStatus.cancelled) {
      return {};
    }else if (result.status == LoginStatus.failed) {
      return null;
    }
    return null;
  }

  Future<Map<dynamic, dynamic>?> signInWithTwitter() async {
    final result = await twitterSignIn.loginV2(forceLogin: true);
    switch (result.status!) {
      case TwitterLoginStatus.loggedIn:
        User? user = await _signInWithTwitter(result.authToken!, result.authTokenSecret!);
        if (user == null) {
          return null;
        }
        Map profile = {};
        profile['userid'] = user.uid;
        profile['token'] = await user.getIdToken();
        profile['email'] = user.email;
        profile['name'] = user.displayName;
        profile['profile_image_url'] = user.photoURL;
        return profile;
      
      case TwitterLoginStatus.cancelledByUser:
        return {};
      
      case TwitterLoginStatus.error:
        return null;
    }
  }

  Future<User?> _signInWithFacebook(String token) async {
    final AuthCredential credential = FacebookAuthProvider.credential(token);
    final User? user;
    try {
      user = (await _auth.signInWithCredential(credential)).user;
      if (user == null) {
        return null;
      }else {
        assert(user.email != null);
        assert(user.displayName != null);
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        final User currentUser = _auth.currentUser!;
        assert(user.uid == currentUser.uid);
        return user;
      }
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {

      }
      return null;
    }
  }

  Future<User?> _signInWithTwitter(String token, String secret) async {
    final AuthCredential credential = TwitterAuthProvider.credential(accessToken: token, secret: secret);
    final User? user = (await _auth.signInWithCredential(credential)).user;
    if (user == null) return null;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    // final User? currentUser = _auth.currentUser;
    return user;
  }

 

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<dynamic, dynamic>?> signInWithApple() async {
    
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
    } catch (e) {
      print(e.toString());
      return {};
    }
    

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final UserCredential authResult = await _auth.signInWithCredential(oauthCredential);
    final User? user = authResult.user;
    if (user == null) return null;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser!;
    if(user.uid == currentUser.uid){
      String token = await user.getIdToken();
      return {
        'userid': user.uid,
        'token': token,
        'email': user.email,
        'name': user.displayName,
        'profile_image_url': user.photoURL
      };
    }
    return null;
  }

  

  Future<bool> restorePasswordRequest(Map<String, dynamic> params) async {
    try{
      final result = await postData(RESTORE_PASSWORD_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body)['status'];
      }
    }
    catch(exception){
      // print(exception);
    }
    return false;
  }

  Future<Map<dynamic, dynamic>?> resetPasswordRequest(Map<String, dynamic> params) async {
    try{
      final result = await postData(RESET_PASSWORD_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return null;
  }



}