import 'dart:convert';
import 'dart:io';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/services/restclient.dart';

class ProfileRepository extends RestApiClient{
  ProfileRepository();

  Future<dynamic> updateAvatar(File avatar) async {
    try{
      final result = await uploadData(UPDATE_AVATAR_URL, avatar);
      if(result.statusCode == HttpStatus.ok){
        return result;
      }
    }
    catch(exception){
      // print(exception);
      return {};
    }
  }
  
  Future<Map<dynamic, dynamic>> completeProfile(Map<String, dynamic> profileData) async {
    try{
      final result = await postData(COMPLETE_PROFILE_URL, profileData);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> getProfile(Map<String, dynamic> params) async {
    try{
      final result = await postData(GET_PROFILE_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> fetchFeed(Map<String, dynamic> params) async {
    try{
      final result = await postData(FETCH_PROFILE_FEED_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> followManage(Map<String, dynamic> params) async {
    try{
      final result = await postData(FOLLOW_MANAGE_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> blockManage(Map<String, dynamic> params) async {
    try{
      final result = await postData(BLOCK_MANAGE_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> fetchCommunity(Map<String, dynamic> params) async {
    try{
      final result = await postData(FETCH_COMMUNITY_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> confirmCommunity(Map<String, dynamic> params) async {
    try{
      final result = await postData(CONFIRM_COMMUNITY_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> fetchFollowers(Map<String, dynamic> params) async {
    try{
      final result = await postData(FETCH_FOLLOWERS_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> fetchFollowings(Map<String, dynamic> params) async {
    try{
      final result = await postData(FETCH_FOLLOWINGS_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> fetchBlockedUsers(Map<String, dynamic> params) async {
    try{
      final result = await postData(FETCH_BLOCKED_USERS_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> changePassword(Map<String, dynamic> params) async {
    try{
      final result = await postData(CHANGE_PASSWORD_URL, params);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }
}