import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime_type/mime_type.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/models/user_model.dart';
import 'package:overheard/ui/components/glassmorphism.dart';
// import 'package:overheard/ui/components/video_player.dart';
import 'package:overheard/ui/feed/bloc/feed_bloc.dart';
import 'package:overheard/ui/feed/bloc/feed_event.dart';
import 'package:overheard/ui/feed/bloc/feed_state.dart';
import 'package:overheard/ui/feed/feed.dart';
import 'package:overheard/ui/feed/models/FeedModel.dart';
import 'package:overheard/ui/feed/repository/feed.repository.dart';
import 'package:overheard/ui/profile/bloc/profile_bloc.dart';
import 'package:overheard/ui/profile/profile.dart';
import 'package:overheard/ui/profile/repository/profile.repository.dart';
import 'package:overheard/utils/ui_elements.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../edit.dart';
import '../post_detail.dart';
import '../report.dart';

class FeedItem extends StatefulWidget{
  final UserModel userModel;
  final FeedModel feed;
  // final FeedScreenState parentState;
  final bool isDetail;
  final bool isProfile;

  // ignore: use_key_in_widget_constructors
  const FeedItem({
    // required this.parentState,
    Key? key,
    required this.userModel, 
    required this.feed, 
    required this.isDetail, 
    required this.isProfile
  });
  @override
  FeedItemState createState() {
    return FeedItemState();
  }

}

class FeedItemState extends State<FeedItem> {
  late FeedBloc feedBloc;
  late FeedScreenState parentState;

  int media_index = 0;

  @override
  void initState(){
    super.initState();
    // parentState = widget.parentState;
    feedBloc = FeedBloc(feedRepository: FeedRepository());
    feedBloc.userModel = widget.userModel;
    feedBloc.feedItem = widget.feed;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: feedBloc,
      listener: (context, state){
        if(state is FeedDeleteDoneState){
          parentState.feedBloc.add(const FeedFetchEvent());
        }
      },
      child: BlocBuilder<FeedBloc, FeedState>(
        bloc: feedBloc,
        builder: (context, state){
          return Column(
            children: [
              Glassmorphism(
                blur: 20, 
                opacity: 0.2, 
                borderRadius: 0, 
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(!widget.isProfile){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                              child: ProfileScreen(
                                user_id: feedBloc.feedItem.publisher!.id!,
                                isMine: feedBloc.feedItem.publisher!.id == feedBloc.userModel.id,
                              ),
                            )));
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            /// Avatar
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProfileAvatar(
                                '',
                                child: feedBloc.feedItem.publisher!.avatar == null || feedBloc.feedItem.publisher!.avatar!.isEmpty ? Image.asset(
                                  'assets/images/user_avatar.png',
                                ):
                                CachedNetworkImage(
                                  imageUrl: feedBloc.feedItem.publisher!.avatar!,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                  placeholder: (context, url) => const CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                                backgroundColor: Colors.transparent,
                                borderColor: Colors.transparent,
                                elevation: 2,
                                radius: 50,
                              ),
                            ),
                            const SizedBox(width: 20,),
                            /// Author name part
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${feedBloc.feedItem.publisher!.firstname ?? ''} ${feedBloc.feedItem.publisher!.lastname ?? ''}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: primaryWhiteTextColor,
                                                fontSize: primaryFeedAuthorFontSize
                                            ),
                                            textScaleFactor: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 140,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            /// This will be real location
                                            feedBloc.feedItem.location ?? '',
                                            style: const TextStyle(
                                                color: primaryWhiteTextColor,
                                                fontSize: primaryFeedAuthorFontSize - 3,
                                                
                                            ),
                                            textScaleFactor: 1.0,
                                          ), 
                                        )
                                        
                                      ],
                                    ),
                                  ),
                                  Text(
                                    feedBloc.feedItem.postDatetime != null ? timeago.format(DateTime.parse(feedBloc.feedItem.postDatetime!)) : '',
                                    style: const TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryFeedAuthorFontSize - 3
                                    ),
                                    textScaleFactor: 1.0,
                                  ),
                                ],
                              ),
                            ),
                            /// Function Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: (){
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => CupertinoActionSheet(
                                        actions: [
                                          CupertinoActionSheetAction(
                                            child: const Text(
                                              reportText,
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: primaryButtonFontSize
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                                                create: (context) => FeedBloc(feedRepository: FeedRepository()),
                                                child: ReportScreen(feed: feedBloc.feedItem),
                                              )));
                                            },
                                          ),
                                          /// Share Button
                                          CupertinoActionSheetAction(
                                            child: const Text(
                                              shareText,
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: primaryButtonFontSize
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                            onPressed: () async {
                                              if(feedBloc.feedItem.media.isEmpty) {
                                                Share.share(feedBloc.feedItem.media[media_index].url!, subject: feedBloc.feedItem.title);
                                              }
                                              else {
                                                Share.share(feedBloc.feedItem.content!, subject: feedBloc.feedItem.title);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          /// Copy Link Button
                                          CupertinoActionSheetAction(
                                            child: const Text(
                                              copyLinkText,
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: primaryButtonFontSize
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                            onPressed: () async {
                                              FlutterClipboard.copy(feedBloc.feedItem.media[media_index].url!).then(( value ) => showToast(copyClipboard, gradientStart));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          /// if feed is other's, disable edit, delete function
                                          widget.userModel.id == feedBloc.feedItem.publisher!.id ?
                                          CupertinoActionSheetAction(
                                            child: const Text(
                                              editText,
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: primaryButtonFontSize
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                                                create: (context) => FeedBloc(feedRepository: FeedRepository()),
                                                child: EditScreen(feed: feedBloc.feedItem),
                                              )));
                                              if(result != null && result){
                                                //parentState.feedBloc.add(FeedFetchEvent());
                                                feedBloc.add(GetFeedEvent(feedId: feedBloc.feedItem.id!));
                                              }
                                            },
                                          ):
                                          const Text(''),
                                          widget.userModel.id == feedBloc.feedItem.publisher!.id ?
                                          CupertinoActionSheetAction(
                                            child: const Text(
                                              deleteText,
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: primaryButtonFontSize
                                              ),
                                              textScaleFactor: 1.0,
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => CupertinoAlertDialog(
                                                  title: const Padding(
                                                    padding: EdgeInsetsDirectional.only(bottom: 10),
                                                    child: Text(
                                                      deletePostAlertTitle,
                                                      style: TextStyle(
                                                          fontSize: primaryButtonFontSize,
                                                          color: primaryBlueTextColor
                                                      ),
                                                      textScaleFactor: 1.0,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    acceptTermsAlertContent,
                                                    style: TextStyle(
                                                        fontSize: primaryButtonMiddleFontSize,
                                                        color: primaryBlueTextColor
                                                    ),
                                                    textScaleFactor: 1.0,
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text(
                                                          cancelButtonText,
                                                          style: TextStyle(
                                                              color: primaryBlueTextColor,
                                                              fontSize: primaryButtonMiddleFontSize
                                                          ),
                                                        )
                                                    ),
                                                    CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                          /// Delete Post Event
                                                          feedBloc.add(FeedDeleteEvent(feed_id: feedBloc.feedItem.id!));
                                                        },
                                                        child: const Text(
                                                          acceptTermsAgreeButtonText,
                                                          style: TextStyle(
                                                              color: primaryBlueTextColor,
                                                              fontSize: primaryButtonMiddleFontSize
                                                          ),
                                                        )
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ):
                                          const Text(''),
                                        ],
                                        cancelButton: CupertinoActionSheetAction(
                                          child: const Text(
                                            doneButtonText,
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: primaryButtonFontSize
                                            ),
                                            textScaleFactor: 1.0,
                                          ),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      )
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 50,
                                  alignment: Alignment.centerRight,
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: primaryWhiteTextColor,
                                    size: 25,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      /// Post Media
                      feedBloc.feedItem.media.isNotEmpty ?
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              if(!widget.isDetail){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                                  create: (context) => FeedBloc(feedRepository: FeedRepository()),
                                  child: PostDetailScreen(feedId: feedBloc.feedItem.id!,),
                                )));
                              }
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.6,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: false,
                                  viewportFraction: 1.0
                                ),
                                items: feedBloc.feedItem.media.asMap().entries.map((entry) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      String mimeType = mime(entry.value.url) as String;
                                      if (imageMimeTypes.contains(mimeType)) {
                                        return Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: entry.value.url!,
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                              ),
                                              placeholder: (context, url) => const CupertinoActivityIndicator(),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                            Positioned(
                                              child: Container(
                                                width: 50,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    gradient: const LinearGradient(
                                                        colors: [gradientStart, gradientEnd]
                                                    )
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    (entry.key + 1).toString() + '/' + feedBloc.feedItem.media.length.toString(),
                                                    style: const TextStyle(
                                                        color: primaryWhiteTextColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    textScaleFactor: 1.0,
                                                  ),
                                                ),
                                              ),
                                              right: 10,
                                              bottom: 10,
                                            )
                                          ],
                                        );  
                                      }
                                      else if (videoMimeTypes.contains(mimeType)) {
                                        return Stack(
                                          children: [
                                            // Container(
                                            //     height: 400,
                                            //     color: Colors.transparent,
                                            //     width: 400 * 16 / 9,
                                            //     child: FeedVideoPlayer(videoUrl: feed.media[index].url, autoPlay: true,)
                                            // ),
                                            Positioned(
                                              child: Container(
                                                width: 50,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  //color: Colors.black87,
                                                    borderRadius: BorderRadius.circular(20),
                                                    gradient: const LinearGradient(
                                                        colors: [gradientStart, gradientEnd]
                                                    )
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    (entry.key + 1).toString() + '/' + feedBloc.feedItem.media.length.toString(),
                                                    style: const TextStyle(
                                                        color: primaryWhiteTextColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    textScaleFactor: 1.0,
                                                  ),
                                                ),
                                              ),
                                              right: 10,
                                              bottom: 10,
                                            )
                                          ],
                                        );
                                      }
                                      else {
                                        return Container();
                                      }
                                      
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      )
                      :
                      const SizedBox.shrink(),
                      /// Post Title
                      feedBloc.feedItem.title != null ?
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                            create: (context) => FeedBloc(feedRepository: FeedRepository()),
                            child: PostDetailScreen(feedId: feedBloc.feedItem.id!),
                          )));
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  feedBloc.feedItem.title ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontSize: primaryButtonFontSize,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ):
                      const SizedBox.shrink(),
                      const SizedBox(height: 10),
                      /// Post Content
                      feedBloc.feedItem.content != null ?
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                            create: (context) => FeedBloc(feedRepository: FeedRepository()),
                            child: PostDetailScreen(feedId: feedBloc.feedItem.id!),
                          )));
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            feedBloc.feedItem.content ?? '',
                            style: const TextStyle(
                                color: primaryWhiteTextColor,
                                fontSize: postContentFontSize
                            ),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ):
                      const SizedBox.shrink(),
                      const SizedBox(height: 10),
                      /// Post Tags
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: postTagFontSize + 5,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: feedBloc.feedItem.tags != null ?
                          feedBloc.feedItem.tags.map((tag){
                            return Text(
                              '#${tag.tag}',
                              textScaleFactor: 1.0,
                              style: const TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: postTagFontSize
                              ),
                            );
                          }).toList() :
                          [],
                        ),
                      ),
                      const SizedBox(height: 10),
                      /// Divider
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: primaryWhiteTextColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 10),
                      /// Bottom Information
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              /// Down Count
                              GestureDetector(
                                onTap: (){
                                  /*if(feedBloc.feedItem.publisher.id == widget.userModel.id){
                                    showToast("You can't vote your post", gradientStart);
                                    return;
                                  }*/
                                  feedBloc.add(FeedVoteEvent(feedId: feedBloc.feedItem.id!, isUp: false));
                                },
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: primaryWhiteTextColor,
                                        size: 15,
                                      ),
                                      Text(
                                        feedBloc.feedItem.downvotes != null ? feedBloc.feedItem.downvotes.toString() : '0',
                                        textScaleFactor: 1.0,
                                        style: const TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: postTagFontSize
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              /// Up Count
                              GestureDetector(
                                onTap: (){
                                  /*if(feedBloc.feedItem.publisher.id == widget.userModel.id){
                                    showToast("You can't vote your post", gradientStart);
                                    return;
                                  }*/
                                  feedBloc.add(FeedVoteEvent(feedId: feedBloc.feedItem.id!, isUp: true));
                                },
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.arrow_drop_up,
                                        color: primaryWhiteTextColor,
                                        size: 15,
                                      ),
                                      Text(
                                        feedBloc.feedItem.upvotes != null ? feedBloc.feedItem.upvotes.toString() : '0',
                                        textScaleFactor: 1.0,
                                        style: const TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: postTagFontSize
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              /// Seen Count
                              const Icon(
                                Icons.visibility,
                                color: primaryWhiteTextColor,
                                size: 15,
                              ),
                              const SizedBox(width: 5,),
                              Text(
                                feedBloc.feedItem.seenCount != null ? feedBloc.feedItem.seenCount.toString() : '0',
                                textScaleFactor: 1.0,
                                style: const TextStyle(
                                    color: primaryWhiteTextColor,
                                    fontSize: postTagFontSize
                                ),
                              ),
                              const SizedBox(width: 10,),
                              /// Comments Count
                              const Icon(
                                Icons.question_answer,
                                color: primaryWhiteTextColor,
                                size: 15,
                              ),
                              const SizedBox(width: 5,),
                              Text(
                                feedBloc.feedItem.commentsCount != null ? feedBloc.feedItem.commentsCount.toString() : '0',
                                textScaleFactor: 1.0,
                                style: const TextStyle(
                                    color: primaryWhiteTextColor,
                                    fontSize: postTagFontSize
                                ),
                              ),
                              const SizedBox(width: 10,),
                            ],
                          ),
                          /// Share Button
                          GestureDetector(
                            onTap: (){
                              if(feedBloc.feedItem.media.isNotEmpty) {
                                Share.share(feedBloc.feedItem.media[media_index].url!, subject: feedBloc.feedItem.title);
                              }
                              else {
                                Share.share(feedBloc.feedItem.content!, subject: feedBloc.feedItem.title);
                              }
                            },
                            child: const Text(
                              'Share',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryFeedAuthorFontSize
                              ),
                            ),
                          )
                          /*feedBloc.feedItem.publisher.id != widget.userModel.id ?
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                                create: (context) => FeedBloc(feedRepository: FeedRepository()),
                                child: ReportScreen(feed: feedBloc.feedItem),
                              )));
                            },
                            child: Text(
                              'Request Reporter',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryFeedAuthorFontSize
                              ),
                            ),
                          ) :
                          SizedBox.shrink()*/
                        ],
                      )
                    ],
                  ),
                ),
               
              ),
              const SizedBox(height: 10,)
            ],
          );
        },
      ),
    );
  }
}