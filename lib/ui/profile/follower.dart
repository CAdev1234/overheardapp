import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/community/models/user.dart';
import 'package:overheard_flutter_app/ui/components/pagination.dart';
import 'package:overheard_flutter_app/ui/profile/bloc/profile.event.dart';
import 'package:overheard_flutter_app/ui/profile/models/FollowModel.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';

import 'bloc/profile.bloc.dart';
import 'bloc/profile.state.dart';

class FollowerScreen extends StatefulWidget{
  @override
  FollowerScreenState createState() {
    return new FollowerScreenState();
  }

}

class FollowerScreenState extends State<FollowerScreen>{
  late ProfileBloc profileBloc;
  int selectedIndex = 0;
  late TextEditingController searchController;
  late TextEditingController followingSearchController;
  @override
  void initState(){
    super.initState();
    profileBloc = ProfileBloc(profileRepository: ProfileRepository());
    profileBloc.add(FollowerFetchEvent(selectedIndex: selectedIndex));
    searchController = TextEditingController();
    followingSearchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: profileBloc,
      listener: (context, state){
        if(state is ProfileLoadDoneState){
          if(selectedIndex == 0){

          }
          else{

          }
        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              followerAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: profileBloc,
            builder: (context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Tab Part
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedIndex = 0;
                                profileBloc.resetFollowr();
                                profileBloc.add(FollowerFetchEvent(selectedIndex: selectedIndex));
                              });
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: Border(
                                  bottom: selectedIndex == 0 ? BorderSide(width: 2, color: gradientStart.withOpacity(0.6)) : BorderSide(width: 1, color: Colors.transparent),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  followersText,
                                  style: TextStyle(
                                      color: selectedIndex == 0 ? primaryWhiteTextColor : primaryWhiteTextColor.withOpacity(0.6)
                                  ),
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedIndex = 1;
                                profileBloc.resetFollowing();
                                profileBloc.add(FollowerFetchEvent(selectedIndex: selectedIndex));
                              });
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: Border(
                                  bottom: selectedIndex == 1 ? BorderSide(width: 2, color: gradientStart.withOpacity(0.6)) : BorderSide(width: 1, color: Colors.transparent),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  followingText,
                                  style: TextStyle(
                                      color: selectedIndex == 1 ? primaryWhiteTextColor : primaryWhiteTextColor.withOpacity(0.6)
                                  ),
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: primaryWhiteTextColor.withOpacity(0.2)
                          ),
                          child: state is ProfileLoadDoneState ?
                          (selectedIndex == 0 ?
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                /// Search Form
                                /*Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 10 * 2,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          textSelectionHandleColor: Colors.transparent,
                                          primaryColor: Colors.transparent,
                                          scaffoldBackgroundColor:Colors.transparent,
                                          bottomAppBarColor: Colors.transparent
                                      ),
                                      child: TextField(
                                        onChanged: (value){
                                          profileBloc.resetFollowr();
                                          profileBloc.followerSearchKey = searchController.text;
                                          profileBloc..add(FollowerFetchEvent(selectedIndex: selectedIndex));
                                          setState(() {

                                          });
                                        },
                                        controller: searchController,
                                        cursorColor: primaryPlaceholderTextColor,
                                        textAlign: TextAlign.start,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: primaryWhiteTextColor),
                                          hintText: searchPlaceholder,
                                          prefixIcon: Icon(Icons.search, color: primaryWhiteTextColor),
                                          suffixIcon: searchController.text.length > 0 ?
                                          GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                searchController.text = "";
                                                profileBloc.initState();
                                                profileBloc.followerSearchKey = searchController.text;
                                                profileBloc..add(FollowerFetchEvent(selectedIndex: selectedIndex));
                                              });
                                            },
                                            child: Icon(Icons.cancel, color: primaryWhiteTextColor),
                                          ):
                                          SizedBox.shrink(),
                                          contentPadding: EdgeInsets.only(
                                            bottom: 40 / 2,  // HERE THE IMPORTANT PART
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: primaryTextFieldFontSize
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),*/
                                Container(
                                  height: MediaQuery.of(context).size.height - 200,
                                  child: PaginationList<FollowModel>(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    prefix: [],
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                    ),
                                    itemBuilder: (BuildContext context, FollowModel follow) {
                                      return Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                          margin: const EdgeInsets.only(top: 3, bottom: 3),
                                          decoration: BoxDecoration(
                                              color: primaryWhiteTextColor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              /// Avatar
                                              Container(
                                                width: 50,
                                                height: 50,
                                                child: CircularProfileAvatar(
                                                  '',
                                                  child: follow.avatar == null || follow.avatar!.length == 0 ? Image.asset(
                                                    'assets/images/user_avatar.png',
                                                  ):
                                                  CachedNetworkImage(
                                                    imageUrl: follow.avatar!,
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
                                              /// Follower name part
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
                                                              follow.name!,
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
                                                  ],
                                                ),
                                              ),
                                              /// Following Button
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    /// UnFollow
                                                    profileBloc.add(ProfileFollowEvent(user_id: follow.id!));
                                                  },
                                                  child: Container(
                                                    width: 70,
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      followingText,
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          color: primaryWhiteTextColor,
                                                          fontSize: primaryButtonMiddleFontSize
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                      );
                                    },
                                    pageFetch: profileBloc.followersFetch,
                                    onError: (dynamic error) => const Center(
                                      child: Text('Something Went Wrong'),
                                    ),
                                    initialData: const <FollowModel>[],
                                    onLoading: const CupertinoActivityIndicator(),
                                    onPageLoading: const CupertinoActivityIndicator(),
                                    onEmpty: const Center(
                                      child: Text(
                                        noFollowersText,
                                        style: TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: primaryButtonFontSize
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ) :
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                /*/// Search Form
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 10 * 2,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          textSelectionHandleColor: Colors.transparent,
                                          primaryColor: Colors.transparent,
                                          scaffoldBackgroundColor:Colors.transparent,
                                          bottomAppBarColor: Colors.transparent
                                      ),
                                      child: TextField(
                                        onChanged: (value){
                                          setState(() {
                                            profileBloc.resetFollowing();
                                            profileBloc.followingSearchKey = followingSearchController.text;
                                            profileBloc..add(FollowerFetchEvent(selectedIndex: selectedIndex));
                                          });
                                        },
                                        controller: followingSearchController,
                                        cursorColor: primaryPlaceholderTextColor,
                                        textAlign: TextAlign.start,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: primaryWhiteTextColor),
                                          hintText: searchPlaceholder,
                                          prefixIcon: Icon(Icons.search, color: primaryWhiteTextColor),
                                          suffixIcon: searchController.text.length > 0 ?
                                          GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                followingSearchController.text = "";
                                                profileBloc.initState();
                                                profileBloc.followingSearchKey = followingSearchController.text;
                                                profileBloc..add(FollowerFetchEvent(selectedIndex: selectedIndex));
                                              });
                                            },
                                            child: Icon(Icons.cancel, color: primaryWhiteTextColor),
                                          ):
                                          SizedBox.shrink(),
                                          contentPadding: EdgeInsets.only(
                                            bottom: 40 / 2,  // HERE THE IMPORTANT PART
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: primaryTextFieldFontSize
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),*/
                                Container(
                                  height: MediaQuery.of(context).size.height - 200,
                                  child: PaginationList<FollowModel>(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    prefix: [],
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                    ),
                                    itemBuilder: (BuildContext context, FollowModel follow) {
                                      return Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                          margin: const EdgeInsets.only(top: 3, bottom: 3),
                                          decoration: BoxDecoration(
                                              color: primaryWhiteTextColor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              /// Avatar
                                              Container(
                                                width: 50,
                                                height: 50,
                                                child: CircularProfileAvatar(
                                                  '',
                                                  child: follow.avatar == null || follow.avatar!.length == 0 ? Image.asset(
                                                    'assets/images/user_avatar.png',
                                                  ):
                                                  CachedNetworkImage(
                                                    imageUrl: follow.avatar!,
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
                                              /// Following name part
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
                                                              follow.name!,
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
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                      );
                                    },
                                    onLoading: const CupertinoActivityIndicator(),
                                    onPageLoading: const CupertinoActivityIndicator(),
                                    pageFetch: profileBloc.followingsFetch,
                                    onError: (dynamic error) => const Center(
                                      child: Text('Something Went Wrong'),
                                    ),
                                    initialData: const <FollowModel>[],
                                    onEmpty: const Center(
                                      child: Text(
                                        noFollowingsText,
                                        style: TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: primaryButtonFontSize
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )) :
                          const Center(child: CupertinoActivityIndicator(),)
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}