import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/numericalset.dart';
import 'package:overheard/ui/auth/models/user_model.dart';
import 'package:overheard/ui/community/models/community_model.dart';
import 'package:overheard/ui/community/repository/community.repository.dart';
import 'package:overheard/utils/ui_elements.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState>{
  final CommunityRepository communityRepository;
  int currentPage = 1;
  int lastFetchedId = 0;
  int? joinedCommunity = 0;
  String searchKey = "";
  late UserModel userModel;
  Position? currentPosition;
  List<CommunityModel> fetchedCommunities = [];

   CommunityBloc({required this.communityRepository}) : super(null as CommunityState) {
     on<CommunityEvent>(
       (event, emit) {
         if (event is CommunityResetEvent) {_mapResetEventToState(event);}
         else if (event is FetchCommunityEvent) {_mapFetchEventToState(event);}
         else if (event is CommunityConfirmEvent) {_mapConfirmEventToState(event);}
         else if (event is CommunitySubmitEvent) {_mapCommunitySubmitToState(event);}
       }
     );
   }

  void resetBloc(){
    currentPage = 1;
    lastFetchedId = 0;
    joinedCommunity = null;
  }


  Future<List<CommunityModel>> pageFetch(int offset) async {
    if(currentPosition == null){
      currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    }
    var params = {
      'page': currentPage,
      'pageCount': communityPageCount,
      'searchKey': searchKey,
      'lat': currentPosition?.latitude,
      'lng': currentPosition?.longitude
    };
    var result = await communityRepository.fetchCommunity(params);
    List<CommunityModel> fetchedCommunities = [];
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      if(userModel.community_id != null){
        joinedCommunity = userModel.community_id as int;
      }
      fetchedCommunities = (result['communities'] as List).map((community) => CommunityModel.fromJson(community)).toList();
      if(fetchedCommunities.isNotEmpty && fetchedCommunities.last.id as int > lastFetchedId){
        currentPage++;
        lastFetchedId = fetchedCommunities.last.id as int;
        return fetchedCommunities;
      }
      else{
        return [];
      }
    }
    else{
      showToast(result['message'], gradientStart);
      return [];
    }

  }

  void _mapFetchEventToState(FetchCommunityEvent communityFetchEvent) async {
    emit(const CommunityLoadingState());
    try {
      if(currentPosition == null){
        currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }
      
      var params = {
        'page': currentPage,
        'pageCount': communityPageCount,
        'searchKey': searchKey,
        'lat': currentPosition?.latitude,
        'lng': currentPosition?.longitude
      };
      var result = await communityRepository.fetchCommunity(params);
      List<CommunityModel> fetchedCommunities = [];
      if(result['status']){
        userModel = UserModel.fromJson(result['user']);
        if(userModel.community_id != null){
          joinedCommunity = userModel.community_id as int;
        }
        fetchedCommunities = (result['communities'] as List).map((community) => CommunityModel.fromJson(community)).toList();
        this.fetchedCommunities = fetchedCommunities;
        emit(const CommunityDoneState());
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        this.fetchedCommunities = [];
        emit(const CommunityLoadFailedState());
        return;
      }
    }
    catch(exception) {
      emit(const CommunityLoadFailedState());
      return;
    }
  }

  void _mapResetEventToState(CommunityResetEvent communityResetEvent) async {
    emit(const CommunityLoadingState());
    var params = {
      'page': currentPage,
      'pageCount': communityPageCount,
      'searchKey': searchKey,
      'lat': currentPosition?.latitude,
      'lng': currentPosition?.longitude
    };
    var result = await communityRepository.fetchCommunity(params);
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      fetchedCommunities = (result['communities'] as List).map((community) => CommunityModel.fromJson(community)).toList();
      emit(const CommunityDoneState());
    }
    else{
      emit(const CommunityLoadFailedState());
    }
  }

  void _mapConfirmEventToState(CommunityConfirmEvent communityConfirmEvent) async {
    emit(const CommunityConfirmLoadingState());
    var params = {
      'community_id': joinedCommunity
    };
    var result = await communityRepository.confirmCommunity(params);
    if(result['status']){
      emit(const CommunityConfirmedState());
    }
    else{
      emit(const CommunityConfirmFailedState());
    }
  }

  void _mapCommunitySubmitToState(CommunitySubmitEvent submitEvent) async {
    emit(const CommunityLoadingState());
    var params = {
      'lat': submitEvent.lat,
      'lng': submitEvent.lng,
      'community_name': submitEvent.name,
    };
    try{
      var result = await communityRepository.submitCommunity(params);
      if(result['status']){
        showToast(result['message'], gradientStart, gravity: ToastGravity.CENTER);
        emit(const CommunityDoneState());
        return;
      }
      else{
        emit(const CommunityLoadFailedState());
        showToast(result['message'], gradientStart, gravity: ToastGravity.CENTER);
        return;
      }
    }
    catch(exception){
      emit(const CommunityLoadFailedState());
      showToast('Community Submit Failed', gradientStart, gravity: ToastGravity.CENTER);
      return;
    }
  }
}