import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
// import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed_event.dart';
import 'package:overheard_flutter_app/ui/feed/models/FeedModel.dart';
import 'package:overheard_flutter_app/ui/feed/repository/feed.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';

import 'bloc/feed_bloc.dart';
import 'bloc/feed_state.dart';

class ReportScreen extends StatefulWidget{
  final FeedModel feed;
  // ignore: use_key_in_widget_constructors
  const ReportScreen({Key? key, required this.feed});
  @override
  ReportScreenState createState() {
    return ReportScreenState();
  }

}

class ReportScreenState extends State<ReportScreen>{
  late FeedBloc feedBloc;
  late TextEditingController reasonController;
  late TextEditingController contentController;

  @override
  void initState(){
    super.initState();
    feedBloc = FeedBloc(feedRepository: FeedRepository());
    reasonController = TextEditingController();
    contentController = TextEditingController();
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
          appBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  CancelButtonText,
                  style: TextStyle(
                      color: primaryWhiteTextColor,
                      fontSize: primaryButtonMiddleFontSize
                  ),
                  textScaleFactor: 1.0,
                ),
              ),
            ),
            middle: const Text(
              reportAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
            trailing: GestureDetector(
              onTap: (){
                if(reasonController.text == ""){
                  showToast(reportReasonEmptyErrorText, gradientStart, gravity: ToastGravity.CENTER);
                  return;
                }
                if(contentController.text == ""){
                  showToast(reportContentEmptyErrorText, gradientStart, gravity: ToastGravity.CENTER);
                  return;
                }
                feedBloc.add(ReportFeedEvent(
                  feed: widget.feed,
                  reason: reasonController.text,
                  reportContent: contentController.text
                ));
              },
              child: const SizedBox(
                width: 50,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    SendButtonText,
                    style: TextStyle(
                        color: primaryWhiteTextColor,
                        fontSize: primaryButtonMiddleFontSize
                    ),
                    textScaleFactor: 1.0,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocListener(
            bloc: feedBloc,
            listener: (context, state){
              if(state is FeedLoadDoneState){
                Navigator.of(context).pop();
              }
            },
            child: BlocBuilder<FeedBloc, FeedState>(
              bloc: feedBloc,
              builder: (context, state){
                return SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SingleChildScrollView(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10,),
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.only(left: 10, right: 10),
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
                                    controller: reasonController,
                                    cursorColor: primaryPlaceholderTextColor,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: primaryWhiteTextColor,
                                      ),
                                      hintText: reportReasonPlaceholder,
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
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width - 10 * 2,
                                height: MediaQuery.of(context).size.height - 160,
                                alignment: Alignment.topLeft,
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
                                  child: TextFormField(
                                    controller: contentController,
                                    cursorColor: primaryPlaceholderTextColor,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: primaryWhiteTextColor,
                                      ),
                                      hintText: reportContentPlaceholder,
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
                            ],
                          ),
                        ),
                      ),
                      state is FeedLoadingState ?
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ) :
                      const SizedBox.shrink()
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}