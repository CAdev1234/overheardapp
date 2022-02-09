import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime_type/mime_type.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/numericalset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed.event.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed.state.dart';
import 'package:overheard_flutter_app/ui/feed/models/CommentItem.dart';
import 'package:overheard_flutter_app/ui/feed/models/FeedModel.dart';
import 'package:overheard_flutter_app/ui/feed/models/MediaType.dart';
import 'package:overheard_flutter_app/ui/feed/repository/feed.repository.dart';
import 'dart:io';

import 'package:overheard_flutter_app/utils/ui_elements.dart';
import 'package:path_provider/path_provider.dart';
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

  FeedBloc({required this.feedRepository}) : super(null as FeedState);

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if(event is FeedFetchEvent){
      yield* _mapFetchFeedEventToState(event);
    }
    else if(event is GetLocationEvent){
      yield* _mapGetLocationEventToState(event);
    }
    else if(event is FeedPostEvent){
      yield* _mapPostEventToState(event);
    }
    else if(event is GetFeedEvent){
      yield* _mapGetFeedEventToState(event);
    }
    else if(event is ReportFeedEvent){
      yield* _mapReportEventToState(event);
    }
    else if(event is LeaveCommentEvent){
      yield* _mapLeaveCommentToState(event);
    }
    else if(event is CommentVoteEvent){
      yield* _mapCommentVoteToState(event);
    }
    else if(event is FeedVoteEvent){
      yield* _mapFeedVoteToState(event);
    }
    else if(event is FeedMediaFetchEvent){
      yield* _mapFeedMediaFetchToState(event);
    }
    else if(event is FeedEditEvent){
      yield* _mapFeedEditEventToState(event);
    }
    else if(event is FeedDeleteEvent){
      yield* _mapFeedDeleteToState(event);
    }
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

  Stream<FeedState> _mapFetchFeedEventToState(FeedFetchEvent feedFetchEvent) async* {
    yield FeedLoadingState();
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
        yield NoCommunityState();
        currentPage = 1;
        return;
      }
    }
    else{
      currentPage = 1;
      yield FeedLoadFailedState();
      return;
    }
    await Future.delayed(
      const Duration(milliseconds: 100),
    );
    currentPage = 1;
    yield FeedLoadDoneState();
  }

  Stream<FeedState> _mapGetFeedEventToState(GetFeedEvent getFeedEvent) async* {
    yield FeedLoadingState();
    var params = {
      'feed_id': getFeedEvent.feedId,
      'filterOption': filterOption
    };
    try{
      var result = await feedRepository.getFeedContent(params);
      if(result['status']){
        UserModel userModel = UserModel.fromJson(result['user']);
        FeedModel feed = FeedModel.fromJson(result['feed']);
        yield FeedLoadDoneState(feed: feed, userModel: userModel);
        return;
      }
      else{
        yield FeedLoadFailedState();
        return;
      }
    }
    catch(exception){
      yield FeedLoadFailedState();
      return;
    }
  }

  Stream<FeedState> _mapGetLocationEventToState(GetLocationEvent getLocationEvent) async* {
    yield FeedLocationGettingState();
    var params = {
      'lat': getLocationEvent.lat,
      'lng': getLocationEvent.lng
    };
    var result = await feedRepository.getLocation(params);
    // List<FeedModel> fetchedModels = [];
    if(result['status']){
      userModel = UserModel.fromJson(result['user']);

    }
    yield FeedLocationGetDoneState();
  }

  Stream<FeedState> _mapPostEventToState(FeedPostEvent feedPostEvent) async* {
    yield FeedPostingState();
    var params = {
      'title': feedPostEvent.title,
      'content': feedPostEvent.content,
      'location': feedPostEvent.location,
      'tags': feedPostEvent.tags
    };

    try{
      var content_result = await feedRepository.postFeedContent(params);
      if(content_result['status']){
        var feed_id = content_result['feed_id'];
        /// Post Feed Attached Files and Feed Id
        var media_params = {
          'feed_id': feed_id,
          'files': feedPostEvent.attaches
        };
        try{
          var attaches_result = await feedRepository.postFeedAttaches(media_params);
          if(attaches_result){
            yield FeedPostDoneState();
            return;
          }
          else{
            showToast('Media Posting Failed', gradientStart);
            yield FeedPostFailedState();
            return;
          }
        }
        catch(exception){
          showToast('Media Posting Failed', gradientStart);
          yield FeedPostFailedState();
          return;
        }

      }
      else{
        showToast('Content Posting Failed', gradientStart); // content_result['message']
        yield FeedPostFailedState();
        return;
      }

    }
    catch(exception){
      showToast('Content Posting Failed', gradientStart);
      yield FeedPostFailedState();
      return;
    }
  }

  Stream<FeedState> _mapReportEventToState(ReportFeedEvent reportFeedEvent) async* {
    yield FeedLoadingState();
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
        yield FeedLoadDoneState();
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        yield FeedLoadFailedState();
        return;
      }
    }
    catch(exception){
      showToast('Reporting Failed', gradientStart);
      yield FeedLoadFailedState();
      return;
    }
  }

  Stream<FeedState> _mapLeaveCommentToState(LeaveCommentEvent leaveCommentEvent) async* {
    yield FeedCommentingState();
    var params = {
      'feed_id': leaveCommentEvent.feed.id,
      'comment': leaveCommentEvent.comment
    };

    try{
      var result = await feedRepository.commentFeed(params);
      if(result['status']){
        yield FeedCommentDoneState();
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        yield FeedCommentFailedState();
        return;
      }
    }
    catch(exception){
      yield FeedCommentFailedState();
      return;
    }
  }

  Stream<FeedState> _mapCommentVoteToState(CommentVoteEvent commentVoteEvent) async* {
    yield FeedCommentingState();
    var params = {
      'comment_id': commentVoteEvent.commentId,
      'isUp': commentVoteEvent.isUp
    };

    try{
      var result = await feedRepository.commentVote(params);
      if(result['status']){
        showToast(result['message'], gradientStart);
        this.commentItem = CommentModel.fromJson(result['comment']);
        yield FeedCommentDoneState();
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        yield FeedCommentFailedState();
        return;
      }
    }
    catch(exception){
      showToast('Vote Failed', gradientStart);
      yield FeedCommentFailedState();
      return;
    }
  }

  Stream<FeedState> _mapFeedVoteToState(FeedVoteEvent feedVoteEvent) async* {
    yield FeedCommentingState();
    var params = {
      'feed_id': feedVoteEvent.feedId,
      'isUp': feedVoteEvent.isUp
    };

    try{
      var result = await feedRepository.feedVote(params);
      if(result['status']){
        showToast(result['message'], gradientStart);
        this.feedItem = FeedModel.fromJson(result['feed']);
        yield FeedCommentDoneState();
        return;
      }
      else{
        showToast(result['message'], gradientStart);
        yield FeedCommentFailedState();
        return;
      }
    }
    catch(exception){
      showToast('Vote Failed', gradientStart);
      yield FeedCommentFailedState();
      return;
    }
  }

  Stream<FeedState> _mapFeedMediaFetchToState(FeedMediaFetchEvent feedMediaFetchEvent) async* {
    yield FeedMediaFetchingState();
    try{
      if(feedItem.media != null && feedItem.media.length > 0){
        for(int i = 0; i < feedItem.media.length; i++){
          String mimeType = mime(feedItem.media[i].url) as String;
          if(imageMimeTypes.contains(mimeType)){
            this.pickedThumbnails.add(MediaType(type: 0, url: feedItem.media[i].url));
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
      yield FeedMediaFetchDoneState();
    }
    catch(exception){
      yield FeedMediaFetchFailedState();
      return;
    }
  }

  Stream<FeedState> _mapFeedEditEventToState(FeedEditEvent feedEditEvent) async* {
    yield FeedLoadingState();
    var params = {
      'feed_id': feedEditEvent.id,
      'title': feedEditEvent.title,
      'content': feedEditEvent.content,
      'tags': feedEditEvent.tags,
      'location': feedEditEvent.location,
      'urls': feedEditEvent.urls.map((item) => item.url != null ? item.url : '').toList()
    };
    try{
      var content_result = await feedRepository.editFeedContent(params);
      if(content_result['status']){
        var feed_id = content_result['feed_id'];
        /// Post Feed Attached Files and Feed Id
        var media_params = {
          'feed_id': feed_id,
          'files': feedEditEvent.attaches
        };
        try{
          var attaches_result = await feedRepository.postFeedAttaches(media_params);
          if(attaches_result){
            showToast('Feed Edit Done', gradientStart);
            yield FeedPostDoneState();
            return;
          }
          else{
            showToast('Media Posting Failed', gradientStart);
            yield FeedPostFailedState();
            return;
          }
        }
        catch(exception){
          showToast('Media Posting Failed', gradientStart);
          yield FeedPostFailedState();
          return;
        }

      }
      else{
        showToast('Content Posting Failed', gradientStart);
        yield FeedPostFailedState();
        return;
      }
    }
    catch(exception){
      yield FeedLoadFailedState();
      return;
    }
  }

  Stream<FeedState> _mapFeedDeleteToState(FeedDeleteEvent feedDeleteEvent) async* {
    yield FeedDeletingState();
    var params = {
      'feed_id': feedDeleteEvent.feed_id
    };
    try{
      var result = await feedRepository.deleteFeedContent(params);
      if(result['status']){
        showToast('Delete Posting Success', gradientStart);
        yield FeedDeleteDoneState();
        return;
      }
      else{
        showToast('Delete Posting Failed', gradientStart);
        yield FeedDeleteFailedState();
        return;
      }
    }
    catch(exception){
      yield FeedDeleteFailedState();
      return;
    }
  }
}