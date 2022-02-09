import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/components/pagination.dart';
import 'package:overheard_flutter_app/ui/profile/bloc/profile.event.dart';
import 'package:overheard_flutter_app/ui/profile/models/BlockedModel.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';

import 'bloc/profile.bloc.dart';
import 'bloc/profile.state.dart';
// import 'models/FollowModel.dart';

class BlockedUserScreen extends StatefulWidget{
  const BlockedUserScreen({Key? key}) : super(key: key);

  @override
  BlockedUserScreenState createState() {
    return BlockedUserScreenState();
  }

}

class BlockedUserScreenState extends State<BlockedUserScreen>{
  late ProfileBloc profileBloc;

  @override
  void initState(){
    super.initState();
    profileBloc = ProfileBloc(profileRepository: ProfileRepository());
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
            return Container(
              decoration: primaryBoxDecoration,
              child: Scaffold(
                appBar: const CupertinoNavigationBar(
                  middle: Text(
                    blockedUserText,
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
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.only(top: 10),
                      child: state is ProfileLoadingState ?
                      const Center(
                        child: CupertinoActivityIndicator(),
                      ):
                      PaginationList<BlockedModel>(
                        shrinkWrap: true,
                        prefix: const [],
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
                        itemBuilder: (BuildContext context, BlockedModel user) {
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
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProfileAvatar(
                                      '',
                                      child: user.avatar == null || user.avatar!.isEmpty ? Image.asset(
                                        'assets/images/user_avatar.png',
                                      ):
                                      CachedNetworkImage(
                                        imageUrl: user.avatar!,
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
                                  /// Username part
                                  Expanded(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - 150,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  user.name!,
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
                                  /// Unblock Button
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: (){
                                        /// UnBlock
                                        profileBloc.add(ProfileBlockEvent(user_id: user.id!));
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 30,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          unblockButtonText,
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
                        pageFetch: profileBloc.blockedUsersFetch,
                        onError: (dynamic error) => const Center(
                          child: Text('Something Went Wrong'),
                        ),
                        initialData: const <BlockedModel>[],
                        onLoading: const CupertinoActivityIndicator(),
                        onPageLoading: const CupertinoActivityIndicator(),
                        onEmpty: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: const Center(
                            child: Text(
                              noBlockedUserText,
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryButtonFontSize
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        )
    );
  }
}