// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/components/glassmorphism.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed_event.dart';
import 'package:overheard_flutter_app/ui/feed/repository/feed.repository.dart';
import 'package:overheard_flutter_app/ui/feed/widgets/comment_item.dart';
import 'package:overheard_flutter_app/ui/feed/widgets/feed_item.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';
// import 'package:timeago/timeago.dart' as timeago;
import 'bloc/feed_bloc.dart';
import 'bloc/feed_state.dart';

class PostDetailScreen extends StatefulWidget{
  final int feedId;
  const PostDetailScreen({Key? key, required this.feedId}) : super(key: key);
  @override
  PostDetailScreenState createState() {
    return PostDetailScreenState();
  }

}

class PostDetailScreenState extends State<PostDetailScreen>{
  late FeedBloc feedBloc;
  late TextEditingController commentController;

  @override
  void initState(){
    super.initState();
    feedBloc = FeedBloc(feedRepository: FeedRepository());
    feedBloc.add(GetFeedEvent(feedId: widget.feedId));
    feedBloc.filterOption = 1;
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: feedBloc,
      listener: (context, state){
        if(state is FeedCommentDoneState){
          feedBloc.add(GetFeedEvent(feedId: widget.feedId));
        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              postDetailAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocBuilder<FeedBloc, FeedState>(
            bloc: feedBloc,
            builder: (context, state){
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: state is FeedLoadingState || state is FeedCommentDoneState || state is FeedCommentingState?
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ):
                      state is FeedLoadDoneState ?
                      SingleChildScrollView(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// Feed Content
                              //feedDetailItem(context, state.userModel, state.feed),
                              FeedItem(feed: state.feed!, userModel: state.userModel!, isDetail: true, isProfile: true,),
                              /// Divider
                              state.feed!.comments.isNotEmpty ?
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                    color: primaryWhiteTextColor.withOpacity(0.7)
                                ),
                              ):
                              const SizedBox.shrink(),
                              /// Comments
                              state.feed!.comments.isNotEmpty ?
                              Container(
                                decoration: BoxDecoration(
                                    color: primaryWhiteTextColor.withOpacity(0.2)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.arrow_drop_down, color: primaryWhiteTextColor,),
                                    DropdownButton(
                                        dropdownColor: gradientEnd,
                                        underline: Container(height: 1, color: Colors.transparent,),
                                        value: feedBloc.filterOption,
                                        icon: const Icon(Icons.arrow_drop_down, color: Colors.transparent,),
                                        items: const [
                                          DropdownMenuItem(
                                            child: Text(
                                              "Recent",
                                              style: TextStyle(
                                                  color: primaryWhiteTextColor,
                                                  fontSize: primaryButtonMiddleFontSize
                                              ),
                                            ),
                                            value: 1,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              "Old",
                                              style: TextStyle(
                                                  color: primaryWhiteTextColor,
                                                  fontSize: primaryButtonMiddleFontSize
                                              ),
                                            ),
                                            value: 2,
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            feedBloc.filterOption = value as int;
                                            feedBloc.add(GetFeedEvent(feedId: widget.feedId));
                                          });
                                        }),
                                  ],
                                ),
                              ):
                              const SizedBox.shrink(),
                              Column(
                                children: state.feed!.comments.map((comment) => CommentItem(comment: comment,)).toList(),
                              )
                            ],
                          ),
                        ),
                      ) :
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: Text(
                            'Getting Feed Failed',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: primaryWhiteTextColor,
                                fontSize: primaryButtonFontSize
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width - 10 * 2 - 50,
                            height: 40,
                            alignment: Alignment.center,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  // textSelectionHandleColor: Colors.transparent,
                                  primaryColor: Colors.transparent,
                                  scaffoldBackgroundColor:Colors.transparent,
                                  bottomAppBarColor: Colors.transparent
                              ),
                              child: Glassmorphism(
                                blur: 20, 
                                opacity: 0.2, 
                                borderRadius: 10, 
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: TextField(
                                    controller: commentController,
                                    cursorColor: primaryPlaceholderTextColor,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: primaryWhiteTextColor,
                                      ),
                                      hintText: commentPlaceholder,
                                      contentPadding: EdgeInsets.only(
                                        bottom: 40 / 2,  // HERE THE IMPORTANT PART
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                              )
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              if(state is FeedLoadDoneState){
                                if(commentController.text == ""){
                                  showToast("Comment has not be empty", gradientStart);
                                  return;
                                }
                                feedBloc.add(LeaveCommentEvent(feed: state.feed!, comment: commentController.text));
                                /*else if(state.feed.publisher.id != state.userModel.id){
                                  commentController.text = '';
                                  feedBloc.add(LeaveCommentEvent(feed: state.feed, comment: commentController.text));
                                }
                                else if(state.feed.publisher.id == state.userModel.id){
                                  showToast('You can not commit your posting', gradientStart);
                                }*/
                              }
                            },
                            icon: const Icon(FontAwesome.send, color: primaryWhiteTextColor,),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}