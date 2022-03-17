import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/community/bloc/community_bloc.dart';
import 'package:overheard/ui/community/community.dart';
import 'package:overheard/ui/community/repository/community.repository.dart';
import 'package:overheard/ui/components/glassmorphism.dart';
import 'package:overheard/ui/components/live_badge.dart';
import 'package:overheard/ui/components/pagination.dart';
import 'package:overheard/ui/feed/bloc/feed_bloc.dart';
import 'package:overheard/ui/feed/bloc/feed_event.dart';
import 'package:overheard/ui/feed/bloc/feed_state.dart';
import 'package:overheard/ui/feed/models/FeedModel.dart';
import 'package:overheard/ui/feed/repository/feed.repository.dart';
import 'package:overheard/ui/feed/widgets/feed_item.dart';
import 'package:overheard/utils/ui_elements.dart';
import 'package:location/location.dart';

class FeedScreen extends StatefulWidget{
  const FeedScreen({Key? key}) : super(key: key);

  @override
  FeedScreenState createState() {
    return FeedScreenState();
  }

}

class FeedScreenState extends State<FeedScreen>{
  late FeedBloc feedBloc;
  late TextEditingController searchController;
  int selectedOption = 1;
  late Timer timer;
  bool enableLiveStreamBlock = true;
  List<String> liveStreamData = [
    "https://images.cointelegraph.com/images/480_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS91cGxvYWRzLzIwMjItMDMvMzBhY2VjM2QtZmNkYy00YTdlLTk5ZGMtMzM0Y2EzYTBiMjNlLmpwZw==.jpg",
    "https://images.cointelegraph.com/images/717_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS91cGxvYWRzLzIwMjItMDMvODNhMzZhMTUtMTZlZS00NDExLTk3MDktNjk4NzcxYTA4ZTE4LmpwZw==.jpg",
    "https://images.cointelegraph.com/images/480_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS91cGxvYWRzLzIwMjItMDMvYTAwZThjZTAtYjMzNy00ZTJiLTg0YTQtYTFkZDY2NGQ1M2FhLmpwZw==.jpg",
    "https://images.cointelegraph.com/images/480_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS91cGxvYWRzLzIwMjItMDMvNWE5NWY4ZDQtNDBjOS00YTg0LWEzZDItOTY5OTI1OTExZTEyLmpwZw==.jpg",
    "https://images.cointelegraph.com/images/717_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS91cGxvYWRzLzIwMjItMDMvODc3YjU3MDUtMjZjYy00OGYzLTk4ZjEtNDYzZjJlNzkyM2NjLmpwZw==.jpg",
    "https://images.cointelegraph.com/images/717_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS91cGxvYWRzLzIwMjItMDMvZTRlZjkxODEtNzFlOC00MDU3LTg0YjgtNmYzNGMxOWRlYTBkLmpwZw==.jpg",
    "https://images.cointelegraph.com/images/717_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS91cGxvYWRzLzIwMjItMDMvMzE5MDMxMmEtYjEyYi00Yjk4LWE3NTQtOGJjODY4YzlmNTc4LmpwZw==.jpg"
  ];

  @override
  void initState(){
    super.initState();
    feedBloc = FeedBloc(feedRepository: FeedRepository());
    feedBloc.filterOption = selectedOption;
    feedBloc.currentPage = 1;
    feedBloc.add(FeedFetchEvent(filterOption: selectedOption));
    searchController = TextEditingController();
  }

  Widget liveStreamBlock() {
    return Glassmorphism(
      blur: 20,
      opacity: 0.2,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Column(
        children: [
          Container(
            height: enableLiveStreamBlock ? 150 : 0,
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width - 10,
            child: enableLiveStreamBlock ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: liveStreamData.asMap().entries.map((entry) {
                  return Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        margin: EdgeInsets.only(left: entry.key > 0 ? 10 : 0),
                        child: CachedNetworkImage(
                          imageUrl: entry.value,
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
                      Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: const LiveBadge(bgColor: Colors.red, width: 10, milliSecond: 1000),
                      ),
                      
                    ],
                  );
                }).toList()
              ),
            ) : const SizedBox.shrink(),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                enableLiveStreamBlock = !enableLiveStreamBlock;
              });
            }, 
            icon: Icon(enableLiveStreamBlock ? Icons.expand_less : Icons.expand_more, size: 30, color: primaryWhiteTextColor,)
          )
          
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: feedBloc,
      listener: (context, state){},
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<FeedBloc, FeedState>(
            bloc: feedBloc,
            builder: (context, state){
              return SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            feedText,
                            style: TextStyle(
                                color: primaryWhiteTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: headingFontSize
                            ),
                            textScaleFactor: 1.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.arrow_drop_down, color: primaryWhiteTextColor,),
                            DropdownButton(
                                dropdownColor: gradientStart,
                                underline: Container(height: 1, color: Colors.transparent,),
                                value: selectedOption,
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
                                      "Most Voted",
                                      style: TextStyle(
                                          color: primaryWhiteTextColor,
                                          fontSize: primaryButtonMiddleFontSize
                                      ),
                                    ),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                      child: Text(
                                        "Most Viewed",
                                        style: TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: primaryButtonMiddleFontSize
                                        ),
                                      ),
                                      value: 3
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value as int;
                                    feedBloc.filterOption = selectedOption;
                                    feedBloc.currentPage = 1;
                                    feedBloc.add(FeedFetchEvent(filterOption: selectedOption));
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),

                    /// Search Form
                    Glassmorphism(
                      blur: 20, 
                      opacity: 0.2, 
                      borderRadius: const BorderRadius.all(Radius.circular(10)), 
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5 * 2,
                        height: 40,
                        alignment: Alignment.center,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              // textSelectionHandleColor: Colors.transparent,
                              primaryColor: Colors.transparent,
                              scaffoldBackgroundColor:Colors.transparent,
                              bottomAppBarColor: Colors.transparent
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value){
                              feedBloc.searchKey = value;
                              try
                              {
                                timer = Timer(const Duration(seconds: 1), () => {
                                  feedBloc.add(FeedFetchEvent(filterOption: selectedOption)),
                                  timer.cancel()
                                });
                              }
                              catch(exception)
                              {
                                // print(exception.toString());
                              }
                            },
                            cursorColor: primaryPlaceholderTextColor,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: const TextStyle(color: primaryWhiteTextColor),
                              hintText: searchPlaceholder,
                              prefixIcon: const Icon(Icons.search, color: primaryWhiteTextColor),
                              suffixIcon: searchController.text.isNotEmpty ?
                              GestureDetector(
                                onTap: (){
                                  searchController.text = "";
                                  feedBloc.searchKey = "";
                                  feedBloc.add(FeedFetchEvent(filterOption: selectedOption));
                                },
                                child: const Icon(Icons.cancel, color: primaryWhiteTextColor),
                              ):
                              const Text(''),
                              contentPadding: const EdgeInsets.only(
                                bottom: 40 / 2,  // HERE THE IMPORTANT PART
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
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
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    liveStreamBlock(),
                    const SizedBox(height: 10),
                    /// Feed List
                    Expanded(
                      child: state is FeedLoadingState ?
                      const CupertinoActivityIndicator() :
                      RefreshIndicator(
                          child: NotificationListener(
                            child: PaginationList<FeedModel>(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              prefix: [
                                state is FeedLoadDoneState ?
                                Column(
                                  children: [
                                    /// Slider
                                    
                                    // const SizedBox(height: 10,)
                                  ],
                                ):
                                state is NoCommunityState ?
                                Column(
                                  children: const [
                                    SizedBox.shrink()
                                  ],
                                ):
                                const SizedBox.shrink()
                              ],
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              itemBuilder: (BuildContext context, FeedModel feed) {
                                return FeedItem(feed: feed, userModel: feedBloc.userModel, isDetail: false, isProfile: false,);
                              },
                              onPageLoading: const CupertinoActivityIndicator(),
                              onLoading: const CupertinoActivityIndicator(),
                              pageFetch: feedBloc.pageFetch,
                              onError: (dynamic error) => const Center(
                                child: Text('Something Went Wrong'),
                              ),
                              initialData: const <FeedModel>[],
                              onEmpty: state is NoCommunityState ?
                              Container(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                                child: Column(
                                  children: [
                                    const Text(
                                      noCommunityFoundText,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: primaryWhiteTextColor,
                                          fontSize: primaryButtonFontSize
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        Location location = Location();

                                        bool _serviceEnabled;
                                        PermissionStatus _permissionGranted;
                                        LocationData _locationData;

                                        _serviceEnabled = await location.serviceEnabled();
                                        if (!_serviceEnabled) {
                                          _serviceEnabled = await location.requestService();
                                          if (!_serviceEnabled) {
                                            showToast(locationPermissionDeniedErrorText, gradientStart.withOpacity(0.8), gravity: ToastGravity.CENTER);
                                            return;
                                          }
                                        }

                                        _permissionGranted = await location.hasPermission();
                                        if (_permissionGranted == PermissionStatus.denied) {
                                          _permissionGranted = await location.requestPermission();
                                          if (_permissionGranted != PermissionStatus.granted) {
                                            showToast(locationPermissionDeniedErrorText, gradientStart.withOpacity(0.8), gravity: ToastGravity.CENTER);
                                            return;
                                          }
                                        }

                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                          create: (context) => CommunityBloc(communityRepository: CommunityRepository()),
                                          child: const CommunityScreen(),
                                        )));
                                      },
                                      child: const Text(
                                        joinCommunityText,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                          color: primaryWhiteTextColor,
                                          fontSize: primaryButtonFontSize,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ):
                              Container(
                                padding: state is NoCommunityState ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35) : EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                                child: const Text(
                                  noFeedFoundText,
                                  style: TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontSize: primaryButtonFontSize
                                  ),
                                ),
                              ),
                            ),
                            onNotification: (t) {
                              if (t is ScrollStartNotification) {
                                setState(() {
                                  enableLiveStreamBlock = false;
                                });
                              }else if (t is ScrollNotification) {

                              }
                              return true;
                            },
                          ),
                          onRefresh: () async {
                            await Future.delayed(
                              const Duration(milliseconds: 100),
                            );
                            feedBloc.add(FeedFetchEvent(filterOption: selectedOption));
                            return;
                          },
                        )
                    ),
                  ],
                )
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}