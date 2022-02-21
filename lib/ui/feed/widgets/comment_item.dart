import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/ui/feed/bloc/feed_bloc.dart';
import 'package:overheard/ui/feed/bloc/feed_event.dart';
import 'package:overheard/ui/feed/bloc/feed_state.dart';
import 'package:overheard/ui/feed/models/CommentItem.dart';
import 'package:overheard/ui/feed/repository/feed.repository.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatefulWidget{
  final CommentModel comment;
  // ignore: use_key_in_widget_constructors
  const CommentItem({required this.comment});
  @override
  CommentItemState createState() {
    return CommentItemState();
  }

}

class CommentItemState extends State<CommentItem> {

  late FeedBloc feedBloc;

  @override
  void initState(){
    super.initState();
    feedBloc = FeedBloc(feedRepository: FeedRepository());
    feedBloc.commentItem = widget.comment;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: feedBloc,
      listener: (context, state){

      },
      child: BlocBuilder<FeedBloc, FeedState>(
        bloc: feedBloc,
        builder: (context, state){
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryWhiteTextColor.withOpacity(0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Avatar
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: feedBloc.commentItem.commentUser![0].avatar == null || feedBloc.commentItem.commentUser![0].avatar!.isEmpty ? Image.asset(
                        'assets/images/user_avatar.png',
                      ):
                      CachedNetworkImage(
                        imageUrl: feedBloc.commentItem.commentUser![0].avatar as String,
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
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 10 * 2 - 50 - 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        feedBloc.commentItem.commentUser![0].firstname! + ' ' + feedBloc.commentItem.commentUser![0].lastname!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: primaryFeedAuthorFontSize,
                                            fontWeight: FontWeight.bold
                                        ),
                                        textScaleFactor: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        timeago.format(DateTime.parse(feedBloc.commentItem.comment!.commentDatetime!), locale: 'es_short'),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: primaryWhiteTextColor,
                                          fontSize: primaryFeedAuthorFontSize,
                                        ),
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.right,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        /// Comment Content
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 10 * 2 - 50 - 10,
                          child: Text(
                            feedBloc.commentItem.comment!.commentContent!,
                            style: const TextStyle(
                                color: primaryWhiteTextColor,
                                fontSize: postContentFontSize
                            ),
                            textScaleFactor: 1.0,
                          ),
                        ),

                        /// Votes
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 10 * 2 - 50 - 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  /// Down Count
                                  GestureDetector(
                                    onTap: (){
                                      feedBloc.add(CommentVoteEvent(commentId: feedBloc.commentItem.comment!.id!, isUp: false));
                                    },
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Entypo.arrow_bold_down,
                                            color: primaryWhiteTextColor,
                                            size: 15,
                                          ),
                                          Text(
                                            feedBloc.commentItem.comment!.downvotes.toString(),
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
                                      feedBloc.add(CommentVoteEvent(commentId: feedBloc.commentItem.comment!.id!, isUp: true));
                                    },
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Entypo.arrow_bold_up,
                                            color: primaryWhiteTextColor,
                                            size: 15,
                                          ),
                                          Text(
                                            feedBloc.commentItem.comment!.upvotes.toString(),
                                            textScaleFactor: 1.0,
                                            style: const TextStyle(
                                                color: primaryWhiteTextColor,
                                                fontSize: postTagFontSize
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              /// Divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                    color: primaryWhiteTextColor.withOpacity(0.7)
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}