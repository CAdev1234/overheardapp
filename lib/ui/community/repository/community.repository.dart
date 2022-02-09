import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/services/restclient.dart';
import 'dart:convert';
import 'dart:io';

class CommunityRepository extends RestApiClient{
  CommunityRepository();

  Future<Map<dynamic, dynamic>> fetchCommunity(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData(FETCH_COMMUNITY_URL, params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      print(exception);
    }
    return Map();
  }

  Future<Map<dynamic, dynamic>> confirmCommunity(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData("$CONFIRM_COMMUNITY_URL", params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      print(exception);
    }
    return Map();
  }

  Future<Map<dynamic, dynamic>> submitCommunity(Map<dynamic, dynamic> params) async {
    try{
      final result = await postData("$SUMBIT_COMMUNITY_URL", params as Map<String, dynamic>);
      if(result!.statusCode == HttpStatus.ok){
        return json.decode(result.body);
      }
    }
    catch(exception){
      print(exception);
    }
    return Map();
  }
}