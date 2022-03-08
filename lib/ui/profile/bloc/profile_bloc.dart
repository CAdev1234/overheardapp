import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/numericalset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/models/user_model.dart';
import 'package:overheard/ui/community/models/community_model.dart';
import 'package:overheard/ui/community/repository/community.repository.dart';
import 'package:overheard/ui/feed/models/FeedModel.dart';
import 'package:overheard/ui/profile/bloc/profile_event.dart';
import 'package:overheard/ui/profile/bloc/profile_state.dart';
import 'package:overheard/ui/profile/models/BlockedModel.dart';
import 'package:overheard/ui/profile/models/FollowModel.dart';
import 'package:overheard/ui/profile/models/ProfileModel.dart';
import 'package:overheard/ui/profile/repository/profile.repository.dart';

import 'package:overheard/utils/ui_elements.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{
  final ProfileRepository profileRepository;
  bool verifiedReporterRequested = false;
  File? avatarImageFile;
  Position? currentPosition;
  List<CommunityModel> fetchedCommunities = [];

  /// Profile UI variables
  late ProfileModel profileModel;
  late UserModel userModel;
  late UserModel viewer;
  late String followText;
  late int? joinedCommunity;
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

  ProfileBloc({required this.profileRepository}) : super(const ProfileInitState()) {
    on<ProfileEvent>(
      (event, emit) => {
        if (event is ProfileCompleteEvent) {
          _mapProfileCompleteEventToState(event)
        }
        else if (event is ProfileFetchEvent) {
          _mapProfileFetchToState(event)
        }
        else if (event is ProfileFollowEvent) {
          _mapProfileFollowEvent(event)
        }
        else if (event is ProfileBlockEvent) {
          _mapProfileBlockEvent(event)
        }
        else if (event is FetchCommunityEvent) {
          communityFetch(event)
        }
        else if (event is CommunityConfirmEvent) {
          _mapConfirmEventToState(event)
        }
        else if (event is CommunityResetEvent) {
          _mapResetEventToState(event)
        }
        else if (event is FollowerFetchEvent) {
          _mapFollowerFetchToState(event)
        }
        else if (event is FetchBlockedUsersEvent) {
          _mapFetchBlockedUserToState(event)
        }
        else if (event is ChangePasswordEvent) {
          _mapPasswordChangeToState(event)
        }
      } 
    );
  }

  @override
  Future<void> close() async {
    super.close();
  }

  void initState(){
    currentPage = 1;
    lastFetchedId = 0;
    joinedCommunity = null;
    
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

  

  void communityFetch(FetchCommunityEvent communityFetchEvent) async {
    emit(const CommunityLoadingState());
    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var params = {
      'page': currentPage,
      'pageCount': communityPageCount,
      'searchKey': searchKey,
      'lat': currentPosition?.latitude,
      'lng': currentPosition?.longitude
    };
    var result = await profileRepository.fetchCommunity(params);
    List<CommunityModel> communities = [];
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      if(userModel.community_id != null){
        joinedCommunity = userModel.community_id!;
      }
      communities = (result['communities'] as List).map((community) => CommunityModel.fromJson(community)).toList();
      if(communities.isNotEmpty && communities.last.id! > lastFetchedId){
        currentPage++;
        lastFetchedId = communities.last.id!;
        fetchedCommunities = communities;
        emit(const CommunityDoneState());
        return;
      }
      else{
        fetchedCommunities = [];
        emit(const CommunityDoneState());
        return;
      }
    }
    else{
      showToast(result['message'], gradientEnd, gravity: ToastGravity.CENTER);
      fetchedCommunities = [];
      emit(const CommunityLoadFailedState());
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

  void _mapProfileCompleteEventToState(ProfileCompleteEvent profileCompleteEvent) async {
    emit(const ProfileLoadingState());
    if(avatarImageFile != null){
      var avatarResponse = await profileRepository.updateAvatar(avatarImageFile!);
      if(avatarResponse == {}){
        showToast('Avatar Update Failed', gradientStart);
        emit(const ProfileUpdateFailedState());
        return;
      }
    }
    var profile = {
      'firstname': profileCompleteEvent.firstName,
      'lastname': profileCompleteEvent.lastName,
      'name': profileCompleteEvent.userName,
      'email': profileCompleteEvent.email,
      'phonenumber': profileCompleteEvent.phonenumber,
      'bio': profileCompleteEvent.bio,
      'reporter_request': profileCompleteEvent.reporter_request == true ? 1 : 0,
    };

    var response = await profileRepository.completeProfile(profile);
    if(response['status']){
      showToast(response['message'], gradientStart);
      emit(const ProfileUpdateDoneState());
      return;
    }
    else{
      showToast(response['message'], gradientStart);
      emit(const ProfileUpdateFailedState());
      return;
    }
  }

  void _mapProfileFetchToState(ProfileFetchEvent profileFetchEvent) async {
    emit(const ProfileLoadingState());
    var result = await profileRepository.getProfile({});
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      viewer = UserModel.fromJson(result['viewer']);
      profileModel = ProfileModel.fromJson(result['profile']);
      followText = profileModel.isFollowing! ? unfollowButtonText : followButtonText;
      emit(ProfileLoadDoneState(userModel: userModel));
      return;
    }
    else{
      showToast('Getting Profile Failed', gradientStart);
      emit(const ProfileLoadFailedState());
      return;
    }
  }

  void _mapProfileFollowEvent(ProfileFollowEvent profileFollowEvent) async {
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
          emit(const ProfileFollowingState());
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          emit(const ProfileLoadDoneState());
          return;
        }
        else{
          followText = followButtonText;
          initState();
          emit(const ProfileFollowingState());
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          emit(const ProfileLoadDoneState());
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

  void _mapProfileBlockEvent(ProfileBlockEvent profileBlockEvent) async {
    var params = {
      'user_id': profileBlockEvent.user_id
    };
    try{
      var result = await profileRepository.blockManage(params);
      if(result['status']){
        bool blocked = result['isBlocked'];
        if(!blocked){
          emit(const ProfileLoadingState());
          resetBlockedUser();
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          emit(const ProfileLoadDoneState());
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

  void _mapResetEventToState(CommunityResetEvent communityResetEvent) async {
    emit(const CommunityLoadingState());
    var params = {
      'page': currentPage,
      'pageCount': communityPageCount,
      'searchKey': searchKey
    };
    var result = await profileRepository.fetchCommunity(params);
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
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
    var result = await profileRepository.confirmCommunity(params);
    if(result['status']){
      emit(const CommunityConfirmedState());
    }
    else{
      emit(const CommunityConfirmFailedState());
    }
  }

  void _mapFollowerFetchToState(FollowerFetchEvent fetchEvent) async {
    emit(const ProfileLoadingState());
    if(fetchEvent.selectedIndex == 0){
      resetFollowr();
    }
    else if(fetchEvent.selectedIndex == 1){
      resetFollowing();
    }
    await Future.delayed(
      const Duration(milliseconds: 100),
    );
    emit(const ProfileLoadDoneState());
  }

  void _mapFetchBlockedUserToState(FetchBlockedUsersEvent fetchBlockedUsersEvent) async {
    emit(const ProfileLoadingState());
    resetBlockedUser();
    await Future.delayed(
      const Duration(milliseconds: 100),
    );
    emit(const ProfileLoadDoneState());
  }

  void _mapPasswordChangeToState(ChangePasswordEvent changePasswordEvent) async {
    emit(const PasswordChangingState());

    var params = {
      'old_password': changePasswordEvent.oldPassword,
      'new_password': changePasswordEvent.newPassword
    };

    var result = await profileRepository.changePassword(params);
    try{
      if(result['status']){
        if(result['changed']){
          showToast(passwordChangedText, gradientStart);
          emit(const PasswordChangedState());
          return;
        }
        else{
          showToast(result['message'], gradientStart);
          emit(const PasswordChangedState());
          return;
        }
      }
      else{
        emit(const PasswordChangeFailedState());
        return;
      }
    }
    catch(exception){
      emit(const PasswordChangeFailedState());
    }
  }
}