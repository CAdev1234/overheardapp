import 'package:equatable/equatable.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/feed/models/FeedModel.dart';

abstract class FeedState extends Equatable{
  FeedState();
}

class FeedLoadingState extends FeedState {
  FeedLoadingState(): super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Init Feeds Loading State';
}

class FeedLoadDoneState extends FeedState {
  final FeedModel? feed;
  final UserModel? userModel;
  FeedLoadDoneState({this.feed, this.userModel}) : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Loading Done State';
}

class NoCommunityState extends FeedState {
  NoCommunityState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'No Community State';
}

class FeedLoadFailedState extends FeedState {
  FeedLoadFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Loading Failed State';
}

class FeedLocationGettingState extends FeedState {
  FeedLocationGettingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Location Getting State';
}

class FeedLocationGetDoneState extends FeedState {
  FeedLocationGetDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Location Getting Done State';
}

class FeedPostingState extends FeedState {
  FeedPostingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Posting State';
}

class FeedPostDoneState extends FeedState {
  FeedPostDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Post Done State';
}

class FeedPostFailedState extends FeedState {
  FeedPostFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Post Feed Failed State';
}

class FeedCommentingState extends FeedState {
  FeedCommentingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Commenting Feed State';
}

class FeedCommentDoneState extends FeedState {
  FeedCommentDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Comment Feed Done State';
}

class FeedCommentFailedState extends FeedState {
  FeedCommentFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Comment Feed Failed State';
}

class FeedMediaFetchingState extends FeedState {
  FeedMediaFetchingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Media Fetching State';
}

class FeedMediaFetchDoneState extends FeedState {
  FeedMediaFetchDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Media Fetch Done';
}

class FeedMediaFetchFailedState extends FeedState {
  FeedMediaFetchFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Media Fetch Failed';
}

class FeedDeletingState extends FeedState {
  FeedDeletingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Deleting State';
}

class FeedDeleteDoneState extends FeedState {
  FeedDeleteDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Delete Done';
}

class FeedDeleteFailedState extends FeedState {
  FeedDeleteFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Delete Failed';
}