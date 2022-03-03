import 'package:overheard/constants/stringset.dart';
import 'package:overheard/services/restclient.dart';
import 'dart:io';
import 'dart:convert';

// import 'package:overheard/ui/feed/models/FeedModel.dart';

class FeedRepository extends RestApiClient{
  FeedRepository();



  Future<Map<dynamic, dynamic>> fetchFeed(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(FETCH_FEED_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }


  Future<Map<dynamic, dynamic>> getLocation(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(GET_LOCATION_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
      return {};
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> postFeedContent(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(POST_FEED_CONTENT_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> editFeedContent(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(EDIT_FEED_CONTENT_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<bool> postFeedAttaches(Map<dynamic, dynamic> params) async {
    try{
      for(int i = 0; i < params['files'].length; i++){
        final result = await uploadDataWithId(POST_FEED_ATTACHES_URL, params['files'][i], params['feed_id']);
        // var resultBody = await result.stream.bytesToString();
        if(result.statusCode == HttpStatus.ok){
          continue;
        }
        else{
          return false;
        }
      }
      return true;
    }
    catch(exception){
      // print(exception);
      return false;
    }
  }

  Future<Map<dynamic, dynamic>> getFeedContent(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(GET_FEED_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> reportFeed(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(REPORT_FEED_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> commentFeed(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(COMMENT_FEED_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> commentVote(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(COMMENT_VOTE_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> feedVote(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(FEED_VOTE_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      // print(exception);
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> deleteFeedContent(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(DELETE_FEED_URL, params as Map<String, dynamic>);
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