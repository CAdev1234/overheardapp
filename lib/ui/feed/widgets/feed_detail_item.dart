import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mime_type/mime_type.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
// import 'package:overheard_flutter_app/ui/components/video_player.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed.bloc.dart';
import 'package:overheard_flutter_app/ui/feed/models/FeedModel.dart';
import 'package:overheard_flutter_app/ui/feed/repository/feed.repository.dart';

import '../edit.dart';
import '../post_detail.dart';
import '../report.dart';

Widget feedDetailItem(BuildContext context, UserModel userModel, FeedModel feed){
  return Column(
    children: [
      Container(
        color: primaryWhiteTextColor.withOpacity(0.2),
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                /// Avatar
                Container(
                  width: 50,
                  height: 50,
                  child: CircularProfileAvatar(
                    '',
                    child: feed.publisher!.avatar == null || feed.publisher!.avatar!.isEmpty ? Image.asset(
                      'assets/images/user_avatar.png',
                    ):
                    CachedNetworkImage(
                      imageUrl: feed.publisher!.avatar!,
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
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                feed.publisher!.firstname! + " " + feed.publisher!.lastname!,
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
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        child: Row(
                          children: [
                            /// This will be enabled with real location
                            /*Text(
                                                        'Como' + ', ',
                                                        style: TextStyle(
                                                            color: primaryWhiteTextColor,
                                                            fontSize: primaryFeedAuthorFontSize - 3
                                                        ),
                                                        textScaleFactor: 1.0,
                                                      ),*/
                            Text(
                              /// This will be real location
                              //feed.location,
                              feed.location!,
                              style: const TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryFeedAuthorFontSize - 3
                              ),
                              textScaleFactor: 1.0,
                            ),
                            const SizedBox(width: 30,),
                            Text(
                              feed.postDatetime!,
                              style: const TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryFeedAuthorFontSize - 3
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
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

                                },
                              ),
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

                                },
                              ),
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

                                },
                              ),
                              /// if feed is other's, disable edit, delete function
                              userModel.id == feed.publisher!.id ?
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
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                    create: (context) => FeedBloc(feedRepository: FeedRepository()),
                                    child: EditScreen(),
                                  )));
                                },
                              ):
                              const Text(''),
                              userModel.id == feed.publisher!.id ?
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

                                },
                              ):
                              const Text(''),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: const Text(
                                DoneButtonText,
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
                      width: 50,
                      height: 50,
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        FontAwesomeIcons.ellipsisH,
                        color: primaryWhiteTextColor,
                        size: 20,
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
            const SizedBox(height: 10),
            /// Post Media
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      String mimeType = mime(feed.media[index].url) as String;
                      if(imageMimeTypes.contains(mimeType)){
                        return Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: feed.media[index].url!,
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
                                    (index + 1).toString() + '/' + feed.media.length.toString(),
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
                      else if(videoMimeTypes.contains(mimeType)){
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
                                    (index + 1).toString() + '/' + feed.media.length.toString(),
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
                      return Container();
                    },
                    itemCount: feed.media.length,
                    viewportFraction: 1.0,
                    scale: 1.0,
                    loop: false,
                  ),
                ),
                const SizedBox(height: 10),
                /// Post Title
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          feed.title!,
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
                const SizedBox(height: 10),
                /// Post Content
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    feed.content!,
                    style: const TextStyle(
                        color: primaryWhiteTextColor,
                        fontSize: postContentFontSize
                    ),
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            /// Post Tags
            Container(
              width: MediaQuery.of(context).size.width,
              height: postTagFontSize + 5,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: feed.tags != null ?
                feed.tags.map((tag){
                  return Text(
                    '#' + tag.tag!,
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

                      },
                      child: Container(
                        child: Row(
                          children: [
                            const Icon(
                              Entypo.arrow_bold_down,
                              color: primaryWhiteTextColor,
                              size: 15,
                            ),
                            Text(
                              feed.downvotes.toString(),
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

                      },
                      child: Container(
                        child: Row(
                          children: [
                            const Icon(
                              Entypo.arrow_bold_up,
                              color: primaryWhiteTextColor,
                              size: 15,
                            ),
                            Text(
                              feed.upvotes.toString(),
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
                      Entypo.eye,
                      color: primaryWhiteTextColor,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      feed.seenCount.toString(),
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                          color: primaryWhiteTextColor,
                          fontSize: postTagFontSize
                      ),
                    ),
                    const SizedBox(width: 10,),
                    /// Comments Count
                    const Icon(
                      Foundation.comments,
                      color: primaryWhiteTextColor,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      feed.commentsCount.toString(),
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                          color: primaryWhiteTextColor,
                          fontSize: postTagFontSize
                      ),
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
                feed.publisher!.id != userModel.id ?
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                      create: (context) => FeedBloc(feedRepository: FeedRepository()),
                      child: ReportScreen(feed: feed),
                    )));
                  },
                  child: const Text(
                    'Request Reporter',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: primaryWhiteTextColor,
                        fontSize: primaryFeedAuthorFontSize
                    ),
                  ),
                ) :
                const SizedBox.shrink()
              ],
            )
          ],
        ),
      ),
      const SizedBox(height: 10,)
    ],
  );
}