// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/services/restclient.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// import 'package:twitter_api/twitter_api.dart';
// import 'package:twitter_login/entity/auth_result.dart';
// import 'package:twitter_login/twitter_login.dart';

class FacebookUserModel {
  String? email;
  String? id;
  String? name;
  FacebookPictureModel? picture;
  AccessToken? token;

  FacebookUserModel({this.email, this.id, this.name, this.picture, this.token});

  FacebookUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'] as String;
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
      // redirectURI: Platform.isAndroid ? 'https://overheard-e21bc.firebaseapp.com/__/auth/handler' : 'twitterkit-D62hrgqhkxMBOhs6r6VxbmBVW://'
      redirectURI: 'overheard-twitter-auth://'
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
      // print(exception);
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

  Future<Map<String, dynamic>?> signInWithFaceBook() async {
    final LoginResult result = await FacebookAuth.i.login();
    if (result.status == LoginStatus.success) {
      AccessToken? token = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      FacebookUserModel user = FacebookUserModel.fromJson(userData);
      user.token = token;
      return user.toJson();
    }else if (result.status == LoginStatus.cancelled) {
      return {};
    }else if (result.status == LoginStatus.failed) {
      return null;
    }
    return null;
    // var facebookLoginResult = await faceBookSignIn.logIn(['email']);

    // switch (facebookLoginResult.status) {
    //   case FacebookLoginStatus.error:
    //     return null;
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     return Map();
    //     break;
    //   case FacebookLoginStatus.loggedIn:
    //     var graphResponse = await http.get(
    //         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');
    //     final AuthCredential credential = FacebookAuthProvider.credential(facebookLoginResult.accessToken.token);
    //     final User user = (await _auth.signInWithCredential(credential)).user;
    //     String token = await user.getIdToken();
    //     var profile = await json.decode(graphResponse.body);
    //     profile['userid'] = user.uid;
    //     profile['token'] = token;
    //     return profile;
    //     break;
    // }
    // return null;
  }

  Future<Map<dynamic, dynamic>?> signInWithTwitter() async {
    try {
      final result = await twitterSignIn.login(forceLogin: true);
      print(result.user);
      switch (result.status!) {
        case TwitterLoginStatus.loggedIn:
          final AuthCredential credential = TwitterAuthProvider.credential(accessToken: result.authToken!, secret: result.authTokenSecret!); 
          return {};

          // Future twitterRequest = _twitterOauth.getTwitterRequest(
          //   // Http Method
          //   "GET",
          //   // Endpoint you are trying to reach
          //   "account/verify_credentials.json",
          // );
          // var res = await twitterRequest;
          // var profile = json.decode(res.body);
          // String token = await user.getIdToken();
          // profile['userid'] = user.uid;
          // profile['token'] = token;
          // profile['email'] = user.email;
          // return profile;
        
        case TwitterLoginStatus.cancelledByUser:
          return {};
        
        case TwitterLoginStatus.error:
          return null;
      }
    } catch (exception) {
      print(exception);
      return null;
    }
    return null;
    
  }


  Future<void> signInWithTwitterWithWebView({required BuildContext context, required String accessToken, required String secret}) async {
    try {
      late UserCredential userCredential;
      if (kIsWeb) {
        TwitterAuthProvider twitterAuthProvider = TwitterAuthProvider();
        await _auth.signInWithPopup(twitterAuthProvider);
      }else {
        final AuthCredential credential = TwitterAuthProvider.credential(
          accessToken: accessToken, 
          secret: secret
        );
        userCredential = await _auth.signInWithCredential(credential);
      }
    } catch (exception) {
      print(exception);
    }
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

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final UserCredential authResult = await _auth.signInWithCredential(oauthCredential);
    final User user = authResult.user as User;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser as User;
    if(user.uid == currentUser.uid){
      String token = await user.getIdToken();
      return {
        'userid': user.uid,
        'token': token,
        'email': user.email,
        'name': "${appleCredential.givenName} ${appleCredential.familyName}",
        'profile_image_url': user.photoURL
      };
    }
    return null;
  }

  Future<User?> _signInWithTwitter(String token, String secret) async {
    final AuthCredential credential = TwitterAuthProvider.credential(
        accessToken: token, secret: secret);
    final User user = (await _auth.signInWithCredential(credential)).user as User;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser as User;
    assert(user.uid == currentUser.uid);

    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<bool> restorePasswordRequest(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(RESTORE_PASSWORD_URL, params as dynamic);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body)['status'];
      }
    }
    catch(exception){
      // print(exception);
    }
    return false;
  }

  Future<Map<dynamic, dynamic>?> resetPasswordRequest(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(RESET_PASSWORD_URL, params as dynamic);
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