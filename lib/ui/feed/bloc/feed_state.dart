import 'package:equatable/equatable.dart';
import 'package:overheard/ui/auth/models/user_model.dart';
import 'package:overheard/ui/feed/models/FeedModel.dart';

abstract class FeedState extends Equatable{
  const FeedState();
}

class FeedInitState extends FeedState {
  const FeedInitState(): super();

  @override
  List<Object> get props => [];
  @override
  String toString() => 'Feed state for null safety';
}

class FeedLoadingState extends FeedState {
  const FeedLoadingState(): super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Init Feeds Loading State';
}

class FeedLoadDoneState extends FeedState {
  final FeedModel? feed;
  final UserModel? userModel;
  const FeedLoadDoneState({this.feed, this.userModel}) : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Loading Done State';
}

class NoCommunityState extends FeedState {
  const NoCommunityState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'No Community State';
}

class FeedLoadFailedState extends FeedState {
  const FeedLoadFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Loading Failed State';
}

class FeedLocationGettingState extends FeedState {
  const FeedLocationGettingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Location Getting State';
}

class FeedLocationGetDoneState extends FeedState {
  const FeedLocationGetDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Location Getting Done State';
}

class FeedLocationGetFailState extends FeedState {
  const FeedLocationGetFailState(): super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Feed Location Getting Failed State';
}
class FeedPostingState extends FeedState {
  const FeedPostingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Posting State';
}

class FeedPostDoneState extends FeedState {
  const FeedPostDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Post Done State';
}

class FeedPostFailedState extends FeedState {
  const FeedPostFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Post Feed Failed State';
}

class FeedCommentingState extends FeedState {
  const FeedCommentingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Commenting Feed State';
}

class FeedCommentDoneState extends FeedState {
  const FeedCommentDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Comment Feed Done State';
}

class FeedCommentFailedState extends FeedState {
  const FeedCommentFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Comment Feed Failed State';
}

class FeedMediaFetchingState extends FeedState {
  const FeedMediaFetchingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Media Fetching State';
}

class FeedMediaFetchDoneState extends FeedState {
  const FeedMediaFetchDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Media Fetch Done';
}

class FeedMediaFetchFailedState extends FeedState {
  const FeedMediaFetchFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Media Fetch Failed';
}

class FeedDeletingState extends FeedState {
  const FeedDeletingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Deleting State';
}

class FeedDeleteDoneState extends FeedState {
  const FeedDeleteDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Delete Done';
}

class FeedDeleteFailedState extends FeedState {
  const FeedDeleteFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Feed Delete Failed';
}