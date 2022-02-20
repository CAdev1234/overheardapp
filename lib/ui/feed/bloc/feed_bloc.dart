import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime_type/mime_type.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/numericalset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed_event.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed_state.dart';
import 'package:overheard_flutter_app/ui/feed/models/CommentItem.dart';
import 'package:overheard_flutter_app/ui/feed/models/FeedModel.dart';
import 'package:overheard_flutter_app/ui/feed/models/MediaType.dart';
import 'package:overheard_flutter_app/ui/feed/repository/feed.repository.dart';
import 'dart:io';

import 'package:overheard_flutter_app/utils/ui_elements.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState>{
  late final FeedRepository feedRepository;
  int currentPage = 1;
  int lastFetchedId = 0;
  String searchKey = "";
  int filterOption = 1;
  late UserModel userModel;
  List<String> tagList = [];

  List<File> pickedFiles = [];
  List<File> thumbnails = [];
  List<MediaType> pickedThumbnails = [];

  List<FeedModel> initFeeds = [];

  /// Feed Item feed
  late FeedModel feedItem;
  late CommentModel commentItem;

  FeedBloc({required this.feedRepository}) : super(null as FeedState) {
    on<FeedEvent>(
      (event, emit) {
        if (event is FeedFetchEvent) {_mapFetchFeedEventToState(event);}
        else if (event is GetLocationEvent) {_mapGetLocationEventToState(event);}
        else if (event is FeedPostEvent) {_mapPostEventToState(event);}
        else if (event is GetFeedEvent) {_mapGetFeedEventToState(event);}
        else if (event is ReportFeedEvent) {_mapReportEventToState(event);}
        else if (event is LeaveCommentEvent) {_mapLeaveCommentToState(event);}
        else if (event is CommentVoteEvent) {_mapCommentVoteToState(event);}
        else if (event is FeedVoteEvent) {_mapFeedVoteToState(event);}
        else if (event is FeedMediaFetchEvent) {_mapFeedMediaFetchToState(event);}
        else if (event is FeedEditEvent) {_mapFeedEditEventToState(event);}
        else if (event is FeedDeleteEvent) {_mapFeedDeleteToState(event);}
      }
    );
  }

  @override
  Future<void> close() async {
    super.close();
  }

  Future<List<FeedModel>> pageFetch(int offset) async {
    var params = {
      'page': currentPage,
      'pageCount': feedPageCount,
      'searchKey': searchKey,
      'filterOption': filterOption,
    };
    var result = await feedRepository.fetchFeed(params);
    List<FeedModel> fetchedModels = [];
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      fetchedModels = (result['feeds'] as List).map((feed) => FeedModel.fromJson(feed)).toList();
      currentPage = result['page'];
      return fetchedModels;
    }
    return fetchedModels;

  }

  void _mapFetchFeedEventToState(FeedFetchEvent feedFetchEvent) async {
    emit(const FeedLoadingState());
    filterOption = feedFetchEvent.filterOption!;
    lastFetchedId = 0;
    var params = {
      'page': 1,
      'pageCount': feedPageCount,
      'searchKey': searchKey,
      'filterOption': filterOption
    };
    var result = await feedRepository.fetchFeed(params);
    List<FeedModel> fetchedModels = [];
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);
      if(userModel.community_id == null){
        emit(const NoCommunityState());
        currentPage = 1;
        return;
      }
    }
    else{
      currentPage = 1;
      emit(const FeedLoadFailedState());
      return;
    }
    await Future.delayed(
      const Duration(milliseconds: 100),
    );
    currentPage = 1;
    emit(const FeedLoadDoneState());
  }

  void _mapGetFeedEventToState(GetFeedEvent getFeedEvent) async {
    emit(const FeedLoadingState());
    var params = {
      'feed_id': getFeedEvent.feedId,
      'filterOption': filterOption
    };
    try{
      var result = await feedRepository.getFeedContent(params);
      if(result['status']){
        UserModel userModel = UserModel.fromJson(result['user']);
        FeedModel feed = FeedModel.fromJson(result['feed']);
        emit(FeedLoadDoneState(feed: feed, userModel: userModel));
        return;
      }
      else{
        emit(const FeedLoadFailedState());
        return;
      }
    }
    catch(exception){
      emit(const FeedLoadFailedState());
      return;
    }
  }

  void _mapGetLocationEventToState(GetLocationEvent getLocationEvent) async {
    emit(const FeedLocationGettingState());
    var params = {
      'lat': getLocationEvent.lat,
      'lng': getLocationEvent.lng
    };
    var result = await feedRepository.getLocation(params);
    // List<FeedModel> fetchedModels = [];
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);

    }
    emit(const FeedLocationGetDoneState());
  }

  void _mapPostEventToState(FeedPostEvent feedPostEvent) async {
    emit(const FeedPostingState());
    var params = {
      'title': feedPostEvent.title,
      'content': feedPostEvent.content,
      'location': feedPostEvent.location,
      'tags': feedPostEvent.tags
    };

    try{
      var contentResult = await feedRepository.postFeedContent(params);
      if(contentResult['status']){
        var feedId = contentResult['feed_id'];
        /// Post Feed Attached Files and Feed Id
        var mediaParams = {
          'feed_id': feedId,
          'files': feedPostEvent.attaches
        };
        try{
          var attachesResult = await feedRepository.postFeedAttaches(mediaParams);
          if(attachesResult){
            emit(const FeedPostDoneState());
            return;
          }
          else{
            showToast('Media Posting Failed', gradientStart);
            emit(const FeedPostFailedState());
            return;
          }
        }
        catch(exception){
          showToast('Media Posting Failed', gradientStart);
          emit(const FeedPostFailedState());
          return;
        }

      }
      else{
        showToast('Content Posting Failed', gradientStart);
        emit(const FeedPostFailedState());
        return;
      }

    }
    catch(exception){
      showToast('Content Posting Failed', gradientStart);
      emit(const FeedPostFailedState());
      return;
    }
  }

  void _mapReportEventToState(ReportFeedEvent reportFeedEvent) async {
    emit(const FeedLoadingState());
    var params = {
      'feed_id': reportFeedEvent.feed.id,
      'reported_author_id': reportFeedEvent.feed.publisher?.id,
      'reason': reportFeedEvent.reason,
      'content': reportFeedEvent.reportContent
    };

    try{
      var result = await feedRepository.reportFeed(params);
      if(result['status']){
        showToast(result['message'], gradientStart);
        emit(const FeedLoadDoneState());
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        emit(const FeedLoadFailedState());
        return;
      }
    }
    catch(exception){
      showToast('Reporting Failed', gradientStart);
      emit(const FeedLoadFailedState());
      return;
    }
  }

  void _mapLeaveCommentToState(LeaveCommentEvent leaveCommentEvent) async {
    emit(const FeedCommentingState());
    var params = {
      'feed_id': leaveCommentEvent.feed.id,
      'comment': leaveCommentEvent.comment
    };

    try{
      var result = await feedRepository.commentFeed(params);
      if(result['status']){
        emit(const FeedCommentDoneState());
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        emit(const FeedCommentFailedState());
        return;
      }
    }
    catch(exception){
      emit(const FeedCommentFailedState());
      return;
    }
  }

  void _mapCommentVoteToState(CommentVoteEvent commentVoteEvent) async {
    emit(const FeedCommentingState());
    var params = {
      'comment_id': commentVoteEvent.commentId,
      'isUp': commentVoteEvent.isUp
    };

    try{
      var result = await feedRepository.commentVote(params);
      if(result['status']){
        showToast(result['message'], gradientStart);
        commentItem = CommentModel.fromJson(result['comment']);
        emit(const FeedCommentDoneState());
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        emit(const FeedCommentFailedState());
        return;
      }
    }
    catch(exception){
      showToast('Vote Failed', gradientStart);
      emit(const FeedCommentFailedState());
      return;
    }
  }

  void _mapFeedVoteToState(FeedVoteEvent feedVoteEvent) async {
    emit(const FeedCommentingState());
    var params = {
      'feed_id': feedVoteEvent.feedId,
      'isUp': feedVoteEvent.isUp
    };

    try{
      var result = await feedRepository.feedVote(params);
      if(result['status']){
        showToast(result['message'], gradientStart);
        feedItem = FeedModel.fromJson(result['feed']);
        emit(const FeedCommentDoneState());
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        emit(const FeedCommentFailedState());
        return;
      }
    }
    catch(exception){
      showToast('Vote Failed', gradientStart);
      emit(const FeedCommentFailedState());
      return;
    }
  }

  void _mapFeedMediaFetchToState(FeedMediaFetchEvent feedMediaFetchEvent) async {
    emit(const FeedMediaFetchingState());
    try{
      if(feedItem.media != null && feedItem.media.isNotEmpty){
        for(int i = 0; i < feedItem.media.length; i++){
          String mimeType = mime(feedItem.media[i].url) as String;
          if(imageMimeTypes.contains(mimeType)){
            pickedThumbnails.add(MediaType(type: 0, url: feedItem.media[i].url));
          }
          else if(videoMimeTypes.contains(mimeType)){
            final thumbnail = await VideoThumbnail.thumbnailFile(
              video: feedItem.media[i].url as String,
              thumbnailPath: (await getTemporaryDirectory()).path,
              imageFormat: ImageFormat.PNG,
              maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
              quality: 25,
            );
            pickedThumbnails.add(MediaType(type: 1, url: feedItem.media[i].url, file: File(thumbnail as String)));
          }
        }
      }
      emit(const FeedMediaFetchDoneState());
    }
    catch(exception){
      emit(const FeedMediaFetchFailedState());
      return;
    }
  }

  void _mapFeedEditEventToState(FeedEditEvent feedEditEvent) async {
    emit(const FeedLoadingState());
    var params = {
      'feed_id': feedEditEvent.id,
      'title': feedEditEvent.title,
      'content': feedEditEvent.content,
      'tags': feedEditEvent.tags,
      'location': feedEditEvent.location,
      'urls': feedEditEvent.urls.map((item) => item.url ?? '').toList()
    };
    try{
      var contentResult = await feedRepository.editFeedContent(params);
      if(contentResult['status']){
        var feedId = contentResult['feed_id'];
        /// Post Feed Attached Files and Feed Id
        var mediaParams = {
          'feed_id': feedId,
          'files': feedEditEvent.attaches
        };
        try{
          var attachesResult = await feedRepository.postFeedAttaches(mediaParams);
          if(attachesResult){
            showToast('Feed Edit Done', gradientStart);
            emit(const FeedPostDoneState());
            return;
          }
          else{
            showToast('Media Posting Failed', gradientStart);
            emit(const FeedPostFailedState());
            return;
          }
        }
        catch(exception){
          showToast('Media Posting Failed', gradientStart);
          emit(const FeedPostFailedState());
          return;
        }

      }
      else{
        showToast('Content Posting Failed', gradientStart);
        emit(const FeedPostFailedState());
        return;
      }
    }
    catch(exception){
      emit(const FeedLoadFailedState());
      return;
    }
  }

  void _mapFeedDeleteToState(FeedDeleteEvent feedDeleteEvent) async {
    emit(const FeedDeletingState());
    var params = {
      'feed_id': feedDeleteEvent.feed_id
    };
    try{
      var result = await feedRepository.deleteFeedContent(params);
      if(result['status']){
        showToast('Delete Posting Success', gradientStart);
        emit(const FeedDeleteDoneState());
        return;
      }
      else{
        showToast('Delete Posting Failed', gradientStart);
        emit(const FeedDeleteFailedState());
        return;
      }
    }
    catch(exception){
      emit(const FeedDeleteFailedState());
      return;
    }
  }
}