// import 'package:json_annotation/json_annotation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/community/models/user.dart';
import 'package:overheard_flutter_app/ui/components/pagination.dart';
import 'package:overheard_flutter_app/ui/feed/models/FeedModel.dart';
import 'package:overheard_flutter_app/ui/feed/widgets/feed_item.dart';
import 'package:overheard_flutter_app/ui/profile/bloc/profile.event.dart';
import 'package:overheard_flutter_app/ui/profile/community.dart';
import 'package:overheard_flutter_app/ui/profile/edit_profile.dart';
import 'package:overheard_flutter_app/ui/profile/follower.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';
import 'package:overheard_flutter_app/ui/profile/settings.dart';

import 'bloc/profile.bloc.dart';
import 'bloc/profile.state.dart';

class ProfileScreenOld extends StatefulWidget{
  final int user_id;
  final bool isMine;
  // ignore: use_key_in_widget_constructors
  const ProfileScreenOld({Key? key, required this.user_id, required this.isMine});
  @override
  ProfileScreenState createState() {
    return ProfileScreenState();
  }

}

class ProfileScreenState extends State<ProfileScreenOld>  with TickerProviderStateMixin
{

  late ProfileBloc profileBloc;
  List<Tab> tabList = [];
  late bool isMine;

  Map<int, Widget> map = {};
  late List<Widget> childWidgets;
  int selectedIndex = 0;

  @override
  void initState(){
    super.initState();
    if(widget.isMine == null){
      isMine = true;
    }
    else{
      isMine = widget.isMine;
    }
    profileBloc = ProfileBloc(profileRepository: ProfileRepository());
    profileBloc.add(ProfileFetchEvent(user_id: widget.user_id));
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: profileBloc,
      listener: (context, state){

      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        builder: (context, state){
          return state is ProfileLoadingState ?
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: primaryBoxDecoration,
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          ) :
          state is ProfileLoadDoneState ?
          Container(
            decoration: primaryBoxDecoration,
            child: Scaffold(
              appBar: CupertinoNavigationBar(
                middle: Text(
                  profileBloc.profileModel.name ?? '',
                  style: const TextStyle(
                      fontSize: appBarTitleFontSize,
                      color: primaryWhiteTextColor
                  ),
                  textScaleFactor: 1.0,
                ),
                trailing: isMine ? GestureDetector(
                  onTap: (){
                    /// This will be different according to user and if user is me, then selected tab index
                    if(selectedIndex == 0){
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            actions: [
                              /*CupertinoActionSheetAction(
                                child: Text(
                                  myEarningsText,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: primaryButtonFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              ),*/
                              CupertinoActionSheetAction(
                                child: const Text(
                                  changeCommunityText,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: primaryButtonFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                    create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                                    child: const EditCommunityScreen(),
                                  )));
                                },
                              ),
                              /// Followers Button
                              CupertinoActionSheetAction(
                                child: const Text(
                                  followersText,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: primaryButtonFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                    create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                                    child: const FollowerScreen(),
                                  )));
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text(
                                  SettingsText,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: primaryButtonFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                    create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                                    child: SettingScreen(),
                                  )));
                                },
                              ),
                              /// Edit Profile Button
                              CupertinoActionSheetAction(
                                child: const Text(
                                  editProfileText,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: primaryButtonFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                onPressed: () async {
                                  var result = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                    create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                                    child: const EditProfileScreen(),
                                  )));
                                  if(result != null && result){
                                    setState(() {
                                      profileBloc.initState();
                                      profileBloc.add(ProfileFetchEvent(user_id: widget.user_id));
                                    });
                                  }
                                },
                              )
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: const Text(
                                CancelButtonText,
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
                    }
                    else{
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            actions: [
                              /// Advertise Post Button
                              CupertinoActionSheetAction(
                                child: const Text(
                                  advertisePostText,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: primaryButtonFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                onPressed: () async {
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
                                  Navigator.of(context).pop();
                                },
                              ),
                              /// Edit Button
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
                                    create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                                    child: const FollowerScreen(),
                                  )));
                                },
                              ),
                              /// Delete Button
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
                                },
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: const Text(
                                CancelButtonText,
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
                    }

                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      FontAwesome.ellipsis_h,
                      color: primaryWhiteTextColor,
                      size: 20,
                    ),
                  ),
                ):
                const SizedBox.shrink(),
              ),
              backgroundColor: Colors.transparent,
              body: BlocBuilder<ProfileBloc, ProfileState>(
                bloc: profileBloc,
                builder: (context, state){
                  return SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          /// Avatar
                          Stack(
                            children: [
                              CircularProfileAvatar(
                                '',
                                child: profileBloc.profileModel.avatar == null || profileBloc.profileModel.avatar!.isEmpty ? Image.asset(
                                  'assets/images/user_avatar.png',
                                ):
                                CachedNetworkImage(
                                  imageUrl: profileBloc.profileModel.avatar!,
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
                              profileBloc.profileModel.isVerified == 1 ? Positioned(
                                right: 10,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.topRight,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/verified.png'
                                      )
                                    )
                                  ),
                                ),
                              ): const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          /// User Name
                          Text(
                            /*profileBloc.profileModel.firstname == null ? "" : profileBloc.profileModel.firstname +
                                ' ' +
                                profileBloc.profileModel.lastname == null ? "" : profileBloc.profileModel.lastname,*/
                            profileBloc.profileModel.firstname!,
                            style: const TextStyle(
                                color: primaryWhiteTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: primaryTextFieldFontSize
                            ),
                            textScaleFactor: 1.0,
                          ),
                          const SizedBox(height: 5),
                          /// Community
                          Text(
                            profileBloc.profileModel.community == null ? 'No Community' : profileBloc.profileModel.community!.name ?? "",
                            style: const TextStyle(
                                color: primaryWhiteTextColor,
                                fontSize: primaryTextFieldFontSize - 2
                            ),
                            textScaleFactor: 1.0,
                          ),
                          const SizedBox(height: 20,),
                          /// Bio Text
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    profileBloc.profileModel.bio ?? "",
                                    style: const TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                    textScaleFactor: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),

                          /// Tab Part
                          isMine ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedIndex = 0;
                                    profileBloc.currentPage = 1;
                                    profileBloc.initState();
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    color: primaryWhiteTextColor.withOpacity(0.2),
                                    border: Border(
                                      bottom: selectedIndex == 0 ? BorderSide(width: 2, color: gradientStart.withOpacity(0.6)) : const BorderSide(width: 1, color: Colors.transparent),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'MY POSTS',
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
                                    profileBloc.currentPage = 1;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    color: primaryWhiteTextColor.withOpacity(0.2),
                                    border: Border(
                                      bottom: selectedIndex == 1 ? BorderSide(width: 2, color: gradientStart.withOpacity(0.6)) : const BorderSide(width: 1, color: Colors.transparent),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'ADVERTISEMENT',
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
                          ):
                          const SizedBox.shrink(),

                          /// Following Button
                          !isMine && state is ProfileLoadDoneState ?
                          GestureDetector(
                            onTap: (){
                              profileBloc.add(ProfileFollowEvent(user_id: widget.user_id));
                            },
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: const EdgeInsets.only(bottom: 30),
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: gradientStart.withOpacity(0.6),
                                    border: Border.all(
                                        color: primaryWhiteTextColor,
                                        width: 1
                                    )
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    profileBloc.followText,
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: primaryButtonMiddleFontSize,
                                        color: primaryWhiteTextColor
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ):
                          const SizedBox.shrink(),

                          !profileBloc.profileModel.isBlocked! ?
                          Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: primaryWhiteTextColor.withOpacity(0.2)
                              ),
                              child: selectedIndex == 0 ?
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(width: 0.5, color: primaryWhiteTextColor)
                                          )
                                      ),
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Amount of posts:',
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: primaryWhiteTextColor,
                                                fontSize: 14
                                            ),
                                          ),
                                          const SizedBox(width: 3,),
                                          Text(
                                            profileBloc.profileModel.totalPost.toString(),
                                            textScaleFactor: 1.0,
                                            style: const TextStyle(
                                                color: primaryWhiteTextColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: isMine ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height - 350,
                                      child: PaginationList<FeedModel>(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        prefix: const [],
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                        ),
                                        itemBuilder: (BuildContext context, FeedModel feed) {
                                          return FeedItem(feed: feed, userModel: profileBloc.viewer, isDetail: false, isProfile: true);
                                        },
                                        onLoading: const CupertinoActivityIndicator(),
                                        onPageLoading: const CupertinoActivityIndicator(),
                                        pageFetch: profileBloc.pageFetch,
                                        onError: (dynamic error) => const Center(
                                          child: Text('Something Went Wrong'),
                                        ),
                                        initialData: const <FeedModel>[],
                                        onEmpty: const Center(
                                          child: Text(
                                            noFeedFountText,
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
                              SizedBox(
                                height: MediaQuery.of(context).size.height - 250,
                                child: PaginationList<User>(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  prefix: const [],
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                  ),
                                  onLoading: const CupertinoActivityIndicator(),
                                  onPageLoading: const CupertinoActivityIndicator(),
                                  itemBuilder: (BuildContext context, User user) {
                                    return ListTile(
                                      title:
                                      Text(user.prefix + " " + user.firstName + " " + user.lastName),
                                      subtitle: Text(user.designation),
                                      leading: IconButton(
                                        icon: const Icon(Icons.person_outline),
                                        onPressed: () => {},
                                      ),
                                      onTap: () => print(user.designation),
                                      trailing: const Icon(
                                        Icons.call,
                                        color: Colors.green,
                                      ),
                                    );
                                  },
                                  pageFetch: pageFetch,
                                  onError: (dynamic error) => const Center(
                                    child: Text('Something Went Wrong'),
                                  ),
                                  initialData: const <User>[

                                  ],
                                  onEmpty: const Center(
                                    child: Text(
                                      noCommunityFountText,
                                      style: TextStyle(
                                          color: primaryWhiteTextColor,
                                          fontSize: primaryButtonFontSize
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ):
                          Column(
                            children: [
                              /// Follow Button
                              GestureDetector(
                                onTap: (){

                                },
                                child: Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: gradientStart.withOpacity(0.6),
                                        border: Border.all(
                                            color: primaryWhiteTextColor,
                                            width: 1
                                        )
                                    ),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        followButtonText,
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: primaryButtonMiddleFontSize,
                                            color: primaryWhiteTextColor
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30,),
                              /// Locked Icon
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: gradientStart.withOpacity(0.6),
                                      border: Border.all(
                                          color: primaryWhiteTextColor,
                                          width: 1
                                      )
                                  ),
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.lock,
                                      color: primaryWhiteTextColor.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'You have been blocked by ${profileBloc.profileModel.name}',
                                        style: const TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: primaryTextFieldFontSize
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ) :
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: primaryBoxDecoration,
            child: const Center(
              child: Text(
                getProfileErrorText,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: primaryWhiteTextColor,
                  fontSize: primaryButtonFontSize
                ),
              ),
            ),
          );
        },
      )
    );
  }

  Future<List<User>> pageFetch(int offset) async {
    final Faker faker = Faker();
    final List<User> upcomingList = List.generate(
      15,
          (int index) => User(
        faker.person.prefix(),
        faker.person.firstName(),
        faker.person.lastName(),
        faker.company.position(),
      ),
    );
    await Future<List<User>>.delayed(
      const Duration(milliseconds: 1500),
    );
    return upcomingList;
  }

}