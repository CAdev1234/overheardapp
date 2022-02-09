import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/numericalset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/community/models/community_model.dart';
import 'package:overheard_flutter_app/ui/feed/models/FeedModel.dart';
import 'package:overheard_flutter_app/ui/profile/bloc/profile.event.dart';
import 'package:overheard_flutter_app/ui/profile/bloc/profile.state.dart';
import 'package:overheard_flutter_app/ui/profile/models/BlockedModel.dart';
import 'package:overheard_flutter_app/ui/profile/models/FollowModel.dart';
import 'package:overheard_flutter_app/ui/profile/models/ProfileModel.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';
import 'dart:io';

import 'package:overheard_flutter_app/utils/ui_elements.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{
  final ProfileRepository profileRepository;
  bool verifiedReporterRequested = false;
  late File? avatarImageFile;
  late Position currentPosition;
  List<CommunityModel> fetchedCommunities = [];

  /// Profile UI variables
  late ProfileModel profileModel;
  late UserModel userModel;
  late UserModel viewer;
  late String followText;
  late int joinedCommunity;
  String searchKey = "";

  /// Bloc variables
  int currentPage = 1;
  int lastFetchedId = 0;

  /// Follow UI variables
  int followerPage = 1;
  int followerLastFetchedId = 0;
  String followerSearchKey = "";
  int followingPage = 1;
  int followingLastFetchId = 0;
  String followingSearchKey = "";

  /// Blocked Users UI variables
  int blockedUserPage = 1;
  int blockedUserLastFetchedId = 0;

  ProfileBloc({required this.profileRepository}) : super(null as ProfileState);

  void initState(){
    currentPage = 1;
    lastFetchedId = 0;
    joinedCommunity = null as int;
  }

  void resetFollowr(){
    followerPage = 1;
    followerLastFetchedId = 0;
  }
  void resetFollowing(){
    followingPage = 1;
    followingLastFetchId = 0;
  }
  void resetBlockedUser(){
    blockedUserPage = 1;
    blockedUserLastFetchedId = 0;
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if(event is ProfileCompleteEvent){
      yield* _mapProfileCompleteEventToState(event);
    }
    else if(event is ProfileFetchEvent){
      yield* _mapProfileFetchToState(event);
    }
    else if(event is ProfileFollowEvent){
      yield* _mapProfileFollowEvent(event);
    }
    else if(event is ProfileBlockEvent){
      yield* _mapProfileBlockEvent(event);
    }
    else if(event is FetchCommunityEvent){
      yield* communityFetch(event);
    }
    else if(event is CommunityConfirmEvent){
      yield* _mapConfirmEventToState(event);
    }
    else if(event is CommunityResetEvent){
      yield* _mapResetEventToState(event);
    }
    else if(event is FollowerFetchEvent){
      yield* _mapFollowerFetchToState(event);
    }
    else if(event is FetchBlockedUsersEvent){
      yield* _mapFetchBlockedUserToState(event);
    }
    else if(event is ChangePasswordEvent){
      yield* _mapPasswordChangeToState(event);
    }
  }

  Future<List<FeedModel>> pageFetch(int offset) async {
    var params = {
      'user_id': userModel.id,
      'page': currentPage,
      'pageCount': feedPageCount,
    };
    var result = await profileRepository.fetchFeed(params);
    List<FeedModel> fetchedModels = [];
    if(result['status']){
      fetchedModels = (result['feeds'] as List).map((feed) => FeedModel.fromJson(feed)).toList();
      if(fetchedModels.isNotEmpty && fetchedModels.last.id! > lastFetchedId){
        currentPage++;
        lastFetchedId = fetchedModels.last.id!;
        return fetchedModels;
      }
      else{
        return [];
      }
    }
    return [];
  }

  Stream<ProfileState> communityFetch(FetchCommunityEvent communityFetchEvent) async* {
    yield CommunityLoadingState();
    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var params = {
      'page': currentPage,
      'pageCount': communityPageCount,
      'searchKey': searchKey,
      'lat': currentPosition.latitude,
      'lng': currentPosition.longitude
    };
    var result = await profileRepository.fetchCommunity(params);
    List<CommunityModel> fetchedCommunities = [];
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      if(userModel.community_id != null){
        joinedCommunity = userModel.community_id!;
      }
      fetchedCommunities = (result['communities'] as List).map((community) => CommunityModel.fromJson(community)).toList();
      if(fetchedCommunities.isNotEmpty && fetchedCommunities.last.id! > lastFetchedId){
        currentPage++;
        lastFetchedId = fetchedCommunities.last.id!;
        this.fetchedCommunities = fetchedCommunities;
        yield CommunityDoneState();
        return;
      }
      else{
        if (result['message']) {
          showToast(result['message'], gradientStart);
        }
        this.fetchedCommunities = [];
        yield CommunityLoadFailedState();
        return;
      }
    }
    else{
      showToast(result['message'], gradientStart);
      this.fetchedCommunities = [];
      yield CommunityLoadFailedState();
      return;
    }
  }

  Future<List<FollowModel>> followersFetch(int offset) async {
    var params = {
      'page': followerPage,
      'pageCount': communityPageCount,
      'searchKey': followerSearchKey
    };
    var result = await profileRepository.fetchFollowers(params);
    List<FollowModel> fetchedModels = [];
    if(result['status']){
      fetchedModels = (result['followers'] as List).map((follow) => FollowModel.fromJson(follow)).toList();
      if(fetchedModels.isNotEmpty && fetchedModels.last.id! > followerLastFetchedId){
        followerPage++;
        followerLastFetchedId = fetchedModels.last.id!;
        return fetchedModels;
      }
      else{
        return [];
      }
    }
    return [];
  }

  Future<List<FollowModel>> followingsFetch(int offset) async {
    var params = {
      'page': followingPage,
      'pageCount': communityPageCount,
      'searchKey': followingSearchKey
    };
    var result = await profileRepository.fetchFollowings(params);
    List<FollowModel> fetchedModels = [];
    if(result['status']){
      fetchedModels = (result['followings'] as List).map((follow) => FollowModel.fromJson(follow)).toList();
      if(fetchedModels.isNotEmpty && fetchedModels.last.id! > followingLastFetchId){
        followingPage++;
        followingLastFetchId = fetchedModels.last.id!;
        return fetchedModels;
      }
      else{
        return [];
      }
    }
    return [];
  }

  Future<List<BlockedModel>> blockedUsersFetch(int offset) async {
    var params = {
      'page': blockedUserPage,
      'pageCount': communityPageCount
    };
    var result = await profileRepository.fetchBlockedUsers(params);
    List<BlockedModel> fetchedModels = [];
    if(result['status']){
      fetchedModels = (result['blocked_users'] as List).map((follow) => BlockedModel.fromJson(follow)).toList();
      if(fetchedModels.isNotEmpty && fetchedModels.last.id! > blockedUserLastFetchedId){
        blockedUserPage++;
        blockedUserLastFetchedId = fetchedModels.last.id!;
        return fetchedModels;
      }
      else{
        return [];
      }
    }
    return [];
  }

  Future<bool> logout() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('AccessToken');
      prefs.remove('AuthorizationToken');
      return true;
    }
    catch(exception){
      return false;
    }
  }

  Stream<ProfileState> _mapProfileCompleteEventToState(ProfileCompleteEvent profileCompleteEvent) async* {
    yield ProfileLoadingState();

    if(avatarImageFile != null){
      var avatar_response = await profileRepository.updateAvatar(avatarImageFile!);
      if(!avatar_response){
        showToast('Avatar Update Failed', gradientStart);
        yield ProfileUpdateFailedState();
        return;
      }
    }

    var profile = {
      'firstname': profileCompleteEvent.firstName,
      'lastname': profileCompleteEvent.lastName,
      'username': profileCompleteEvent.userName,
      'email': profileCompleteEvent.email,
      'phonenumber': profileCompleteEvent.phonenumber,
      'bio': profileCompleteEvent.bio,
      'reporter_request': profileCompleteEvent.reporter_request
    };

    var response = await profileRepository.completeProfile(profile);
    if(response['status']){
      showToast(response['message'], gradientStart);
      yield ProfileUpdateDoneState();
    }
    else{
      showToast(response['message'], gradientStart);
      yield ProfileUpdateFailedState();
    }
  }

  Stream<ProfileState> _mapProfileFetchToState(ProfileFetchEvent profileFetchEvent) async* {
    yield ProfileLoadingState();
    var params = {
      'user_id': profileFetchEvent.user_id
    };
    var result = await profileRepository.getProfile(params);
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      viewer = UserModel.fromJson(result['viewer']);
      profileModel = ProfileModel.fromJson(result['profile']);
      followText = profileModel.isFollowing! ? unfollowButtonText : followButtonText;
      yield ProfileLoadDoneState(userModel: userModel);
      return;
    }
    else{
      showToast('Getting Profile Failed', gradientStart);
      yield ProfileLoadFailedState();
      return;
    }
  }

  Stream<ProfileState> _mapProfileFollowEvent(ProfileFollowEvent profileFollowEvent) async* {
    var params = {
      'user_id': profileFollowEvent.user_id
    };
    try{
      var result = await profileRepository.followManage(params);
      if(result['status']){
        bool following = result['isFollowing'];
        if(following){
          followText = unfollowButtonText;
          initState();
          yield ProfileFollowingState();
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          yield ProfileLoadDoneState();
          return;
        }
        else{
          followText = followButtonText;
          initState();
          yield ProfileFollowingState();
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          yield ProfileLoadDoneState();
          return;
        }
      }
      else{
        showToast(result['message'], gradientStart);
        return;
      }
    }
    catch(exception){
      showToast('Operation Failed', gradientStart);
      return;
    }
  }

  Stream<ProfileState> _mapProfileBlockEvent(ProfileBlockEvent profileBlockEvent) async* {
    var params = {
      'user_id': profileBlockEvent.user_id
    };
    try{
      var result = await profileRepository.blockManage(params);
      if(result['status']){
        bool blocked = result['isBlocked'];
        if(!blocked){
          yield ProfileLoadingState();
          resetBlockedUser();
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          yield ProfileLoadDoneState();
          return;
        }
      }
      else{
        showToast(result['message'], gradientStart);
        return;
      }
    }
    catch(exception){
      showToast('Operation Failed', gradientStart);
      return;
    }
  }

  Stream<ProfileState> _mapResetEventToState(CommunityResetEvent communityResetEvent) async* {
    yield CommunityLoadingState();
    var params = {
      'page': currentPage,
      'pageCount': communityPageCount,
      'searchKey': searchKey
    };
    var result = await profileRepository.fetchCommunity(params);
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      yield CommunityDoneState();
    }
    else{
      yield CommunityLoadFailedState();
    }
  }

  Stream<ProfileState> _mapConfirmEventToState(CommunityConfirmEvent communityConfirmEvent) async* {
    yield CommunityConfirmLoadingState();
    var params = {
      'community_id': joinedCommunity
    };
    var result = await profileRepository.confirmCommunity(params);
    if(result['status']){
      yield CommunityConfirmedState();
    }
    else{
      yield CommunityConfirmFailedState();
    }
  }

  Stream<ProfileState> _mapFollowerFetchToState(FollowerFetchEvent fetchEvent) async* {
    yield ProfileLoadingState();
    if(fetchEvent.selectedIndex == 0){
      resetFollowr();
    }
    else if(fetchEvent.selectedIndex == 1){
      resetFollowing();
    }
    await Future.delayed(
      const Duration(milliseconds: 100),
    );
    yield ProfileLoadDoneState();
  }

  Stream<ProfileState> _mapFetchBlockedUserToState(FetchBlockedUsersEvent fetchBlockedUsersEvent) async* {
    yield ProfileLoadingState();
    resetBlockedUser();
    await Future.delayed(
      const Duration(milliseconds: 100),
    );
    yield ProfileLoadDoneState();
  }

  Stream<ProfileState> _mapPasswordChangeToState(ChangePasswordEvent changePasswordEvent) async* {

    yield PasswordChangingState();

    var params = {
      'old_password': changePasswordEvent.oldPassword,
      'new_password': changePasswordEvent.newPassword
    };

    var result = await profileRepository.changePassword(params);
    try{
      if(result['status']){
        if(result['changed']){
          showToast(passwordChangedText, gradientStart);
          yield PasswordChangedState();
          return;
        }
        else{
          showToast(result['message'], gradientStart);
          yield PasswordChangedState();
          return;
        }
      }
      else{
        yield PasswordChangeFailedState();
        return;
      }
    }
    catch(exception){
      yield PasswordChangeFailedState();
    }
  }
}