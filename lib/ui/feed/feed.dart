import 'dart:async';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/community/bloc/community.bloc.dart';
import 'package:overheard_flutter_app/ui/community/community.dart';
import 'package:overheard_flutter_app/ui/community/repository/community.repository.dart';
import 'package:overheard_flutter_app/ui/components/pagination.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed.bloc.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed.event.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed.state.dart';
import 'package:overheard_flutter_app/ui/feed/models/FeedModel.dart';
import 'package:overheard_flutter_app/ui/feed/repository/feed.repository.dart';
import 'package:overheard_flutter_app/ui/feed/widgets/feed_item.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';
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

  @override
  void initState(){
    super.initState();
    feedBloc = FeedBloc(feedRepository: FeedRepository());
    feedBloc.filterOption = selectedOption;
    feedBloc.currentPage = 1;
    feedBloc.add(FeedFetchEvent(filterOption: selectedOption));
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: feedBloc,
      listener: (context, state){

      },
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
                    Container(
                      width: MediaQuery.of(context).size.width - 10 * 2,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)
                      ),
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
                              // ignore: unnecessary_null_comparison
                              if(timer != null) {
                                timer.cancel();
                              }
                              timer = Timer(const Duration(seconds: 1), () => {
                                feedBloc..add(FeedFetchEvent(filterOption: selectedOption))
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
                    const SizedBox(height: 10),
                    Expanded(
                        child: state is FeedLoadingState ?
                        const CupertinoActivityIndicator() :
                        RefreshIndicator(
                          child: PaginationList<FeedModel>(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            prefix: [
                              state is FeedLoadDoneState ?
                              Column(
                                children: const [
                                  /// Slider
                                  /*Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    color: primaryWhiteTextColor.withOpacity(0.3),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(width: 10,),
                                          Stack(
                                            alignment: AlignmentDirectional.topEnd,
                                            children: [
                                              Container(
                                                height: 130,
                                                width: 130,
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                  ),
                                                  placeholder: (context, url) => CupertinoActivityIndicator(),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                ),
                                              ),
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.lightBlueAccent
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            height: 130,
                                            width: 130,
                                            child: CachedNetworkImage(
                                              imageUrl: "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                              ),
                                              placeholder: (context, url) => CupertinoActivityIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            height: 130,
                                            width: 130,
                                            child: CachedNetworkImage(
                                              imageUrl: "https://images.unsplash.com/photo-1590005354167-6da97870c757?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                              ),
                                              placeholder: (context, url) => CupertinoActivityIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            height: 130,
                                            width: 130,
                                            child: CachedNetworkImage(
                                              imageUrl: "https://images.unsplash.com/photo-1584306670957-acf935f5033c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                              ),
                                              placeholder: (context, url) => CupertinoActivityIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            height: 130,
                                            width: 130,
                                            child: CachedNetworkImage(
                                              imageUrl: "https://images.unsplash.com/photo-1576179635662-9d1983e97e1e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                              ),
                                              placeholder: (context, url) => CupertinoActivityIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            height: 130,
                                            width: 130,
                                            child: CachedNetworkImage(
                                              imageUrl: "https://images.unsplash.com/photo-1512578659172-63a4634c05ec?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                              ),
                                              placeholder: (context, url) => CupertinoActivityIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                        ],
                                      ),
                                    ),
                                  ),*/
                                  SizedBox(height: 10,)
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
                              return FeedItem(parentState: this, feed: feed, userModel: feedBloc.userModel, isDetail: false, isProfile: false,);
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
                                    noCommunityFountText,
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
                                noFeedFountText,
                                style: TextStyle(
                                    color: primaryWhiteTextColor,
                                    fontSize: primaryButtonFontSize
                                ),
                              ),
                            ),
                          ),
                          onRefresh: () async {
                            await Future.delayed(
                              const Duration(milliseconds: 1000),
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
}