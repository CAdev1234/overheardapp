import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:overheard_flutter_app/ui/feed/models/CommentItem.dart';
import 'package:overheard_flutter_app/ui/feed/models/FeedModel.dart';
import 'package:overheard_flutter_app/ui/feed/models/MediaType.dart';

abstract class FeedEvent extends Equatable{
  FeedEvent();

  @override
  List<Object> get pros => [];
}

class FeedFetchEvent extends FeedEvent {
  final int? filterOption;
  FeedFetchEvent({this.filterOption}): super();

  @override
  List<Object> get props => [];
}

class GetLocationEvent extends FeedEvent {
  final double lat;
  final double lng;
  GetLocationEvent({required this.lat, required this.lng}) : super();

  @override
  List<Object> get props => [];
}

/// Publishing Feed Event
class FeedPostEvent extends FeedEvent {
  final String title;
  final String content;
  final String location;
  final List<String> tags;
  final List<File> attaches;
  final List<File> thumbnails;
  FeedPostEvent({required this.title, required this.content, required this.location, required this.tags, required this.attaches, required this.thumbnails}) : super();

  @override
  List<Object> get props => [];
}

class GetFeedEvent extends FeedEvent {
  final int feedId;
  GetFeedEvent({required this.feedId}) : super();

  @override
  List<Object> get props => [];
}

/// Report Feed Event
class ReportFeedEvent extends FeedEvent {
  final FeedModel feed;
  final String reason;
  final String reportContent;
  ReportFeedEvent({required this.feed, required this.reason, required this.reportContent}) : super();

  @override
  List<Object> get props => [];
}

/// Leave Comment Event
class LeaveCommentEvent extends FeedEvent {
  final FeedModel feed;
  final String comment;
  LeaveCommentEvent({required this.feed, required this.comment}) : super();

  @override
  List<Object> get props => [];
}

/// Feed Vote Event
class FeedVoteEvent extends FeedEvent {
  final int feedId;
  final bool isUp;

  FeedVoteEvent({required this.feedId, required this.isUp}) : super();

  @override
  List<Object> get props => [];
}

/// Comment Vote Event
class CommentVoteEvent extends FeedEvent {
  final int commentId;
  final bool isUp;
  CommentVoteEvent({required this.commentId, required this.isUp}): super();

  @override
  List<Object> get props => [];
}

/// Feed Media Fetch Event
class FeedMediaFetchEvent extends FeedEvent {
  final int feedId;
  FeedMediaFetchEvent({required this.feedId}) : super();

  @override
  List<Object> get props => [];
}

/// Feed Edit Event
class FeedEditEvent extends FeedEvent {
  final int id;
  final String title;
  final String content;
  final String location;
  final List<String> tags;
  final List<File> attaches;
  final List<MediaType> urls;
  FeedEditEvent({required this.id, required this.title, required this.content, required this.location, required this.tags, required this.attaches, required this.urls}) : super();

  @override
  List<Object> get props => [];
}

/// Feed Delete Event
class FeedDeleteEvent extends FeedEvent {
  final int feed_id;
  FeedDeleteEvent({required this.feed_id}) : super();

  @override
  List<Object> get props => [];
}