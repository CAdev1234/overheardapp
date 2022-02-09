import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/numericalset.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/community/models/community_model.dart';
import 'package:overheard_flutter_app/ui/community/repository/community.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';

import 'community.event.dart';
import 'community.state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState>{
  final CommunityRepository communityRepository;
  int currentPage = 1;
  int lastFetchedId = 0;
  int? joinedCommunity = 0;
  String searchKey = "";
  late UserModel userModel;
  late Position currentPosition;
  List<CommunityModel> fetchedCommunities = [];

   CommunityBloc({required this.communityRepository}) : super(null as CommunityState);

  void resetBloc(){
    currentPage = 1;
    lastFetchedId = 0;
    joinedCommunity = null;
  }

  @override
  Stream<CommunityState> mapEventToState(CommunityEvent event) async* {
    if(event is CommunityResetEvent){
      yield* _mapResetEventToState(event);
    }
    else if(event is FetchCommunityEvent)
    {
      yield* _mapFetchEventToState(event);
    }
    else if(event is CommunityConfirmEvent){
      yield* _mapConfirmEventToState(event);
    }
    else if(event is CommunitySubmitEvent){
      yield* _mapCommunitySubmitToState(event);
    }
  }

  Future<List<CommunityModel>> pageFetch(int offset) async {
    if(currentPosition == null){
      currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    }
    var params = {
      'page': currentPage,
      'pageCount': communityPageCount,
      'searchKey': searchKey,
      'lat': currentPosition.latitude,
      'lng': currentPosition.longitude
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

  Stream<CommunityState> _mapFetchEventToState(FetchCommunityEvent communityFetchEvent) async* {
    yield CommunityLoadingState();
    try {
      if(currentPosition == null){
        currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }
      var params = {
        'page': currentPage,
        'pageCount': communityPageCount,
        'searchKey': searchKey,
        'lat': currentPosition.latitude,
        'lng': currentPosition.longitude
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
        yield const CommunityDoneState();
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        this.fetchedCommunities = [];
        yield const CommunityLoadFailedState();
        return;
      }
    }
    catch(exception) {
      yield const CommunityLoadFailedState();
      return;
    }
  }

  Stream<CommunityState> _mapResetEventToState(CommunityResetEvent communityResetEvent) async* {
    yield const CommunityLoadingState();
    var params = {
      'page': currentPage,
      'pageCount': communityPageCount,
      'searchKey': searchKey,
      'lat': currentPosition.latitude,
      'lng': currentPosition.longitude
    };
    var result = await communityRepository.fetchCommunity(params);
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      fetchedCommunities = (result['communities'] as List).map((community) => CommunityModel.fromJson(community)).toList();
      yield const CommunityDoneState();
    }
    else{
      yield const CommunityLoadFailedState();
    }
  }

  Stream<CommunityState> _mapConfirmEventToState(CommunityConfirmEvent communityConfirmEvent) async* {
    yield const CommunityConfirmLoadingState();
    var params = {
      'community_id': joinedCommunity
    };
    var result = await communityRepository.confirmCommunity(params);
    if(result['status']){
      yield const CommunityConfirmedState();
    }
    else{
      yield const CommunityConfirmFailedState();
    }
  }

  Stream<CommunityState> _mapCommunitySubmitToState(CommunitySubmitEvent submitEvent) async* {
    yield const CommunityLoadingState();
    var params = {
      'lat': submitEvent.lat,
      'lng': submitEvent.lng,
      'community_name': submitEvent.name
    };
    try{
      var result = await communityRepository.submitCommunity(params);
      if(result['status']){
        showToast(result['message'], gradientStart, gravity: ToastGravity.CENTER);
        yield const CommunityDoneState();
        return;
      }
      else{
        yield const CommunityLoadFailedState();
        showToast(result['message'], gradientStart, gravity: ToastGravity.CENTER);
        return;
      }
    }
    catch(exception){
      yield const CommunityLoadFailedState();
      showToast('Community Submit Failed', gradientStart, gravity: ToastGravity.CENTER);
      return;
    }
  }
}