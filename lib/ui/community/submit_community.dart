import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/community/bloc/community_event.dart';
import 'package:overheard_flutter_app/ui/community/repository/community.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';

import 'bloc/community_bloc.dart';
import 'bloc/community_state.dart';

class SubmitCommunityScreen extends StatefulWidget{
  const SubmitCommunityScreen({Key? key}) : super(key: key);

  @override
  SubmitCommunityScreenState createState() {
    return SubmitCommunityScreenState();
  }

}

class SubmitCommunityScreenState extends State<SubmitCommunityScreen>{
  late CommunityBloc communityBloc;
  late TextEditingController communityNameController;

  @override
  void initState(){
    super.initState();
    communityBloc = CommunityBloc(communityRepository: CommunityRepository());
    communityNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: communityBloc,
      listener: (context, state){
        if(state is CommunityDoneState){
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              submitCommunityAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocBuilder<CommunityBloc, CommunityState>(
            bloc: communityBloc,
            builder: (context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height: 10
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                // textSelectionHandleColor: Colors.white,
                                primaryColor: primaryDividerColor,
                                scaffoldBackgroundColor:Colors.white,
                                // accentColor: Colors.white
                            ),
                            child: TextField(
                              controller: communityNameController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: communityNamePlaceholder,
                                  hintStyle: TextStyle(color: primaryWhiteTextColor),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )
                              ),
                              style: const TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () async {
                            if(communityNameController.text == ""){
                              showToast(communityNameEmptyErrorText, gradientStart);
                              return;
                            }
                            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                            communityBloc.add(CommunitySubmitEvent(lat: position.latitude, lng: position.longitude, name: communityNameController.text));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2, right: MediaQuery.of(context).size.width * 0.2, bottom: 10),
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                                color: gradientStart.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: primaryWhiteTextColor
                                )
                            ),
                            child: state is CommunityLoadingState ?
                            const CupertinoActivityIndicator() :
                            const Text(
                              SubmitButtonText,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryButtonFontSize
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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