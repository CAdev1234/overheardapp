import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/feed/bloc/feed_event.dart';
import 'package:overheard/ui/feed/map_view.dart';
import 'package:overheard/ui/feed/models/FeedModel.dart';
import 'package:overheard/ui/feed/models/MediaType.dart';
import 'package:overheard/ui/feed/models/TagItem.dart';
import 'package:overheard/ui/feed/repository/feed.repository.dart';
import 'package:overheard/utils/ui_elements.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'bloc/feed_bloc.dart';
import 'bloc/feed_state.dart';

class EditScreen extends StatefulWidget{
  final FeedModel? feed;
  // ignore: use_key_in_widget_constructors
  const EditScreen({Key? key, this.feed});
  @override
  EditScreenState createState() {
    return EditScreenState();
  }

}

class EditScreenState extends State<EditScreen>{
  late FeedBloc feedBloc;
  late TextEditingController titleController;
  late TextEditingController contentController;
  var contentNode = FocusNode();
  late TextEditingController tagController;
  late TextEditingController locationController;

  late Offset _tapPosition;
  ItemTagsCombine combine = ItemTagsCombine.onlyText;

  @override
  void initState(){
    super.initState();
    feedBloc = FeedBloc(feedRepository: FeedRepository());
    feedBloc.feedItem = widget.feed!;

    feedBloc.add(FeedMediaFetchEvent(feedId: feedBloc.feedItem.id!));

    titleController = TextEditingController();
    titleController.text = feedBloc.feedItem.title ?? '';
    

    contentController = TextEditingController();
    contentController.text = feedBloc.feedItem.content!;

    tagController = TextEditingController();
    locationController = TextEditingController();
    locationController.text = feedBloc.feedItem.location ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: feedBloc,
      listener: (context, state){
        if(state is FeedPostDoneState){
          Navigator.of(context).pop(true);
        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: (){
                Navigator.of(context).pop(false);
              },
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  cancelButtonText,
                  style: TextStyle(
                      color: primaryWhiteTextColor,
                      fontSize: primaryButtonMiddleFontSize
                  ),
                  textScaleFactor: 1.0,
                ),
              ),
            ),
            middle: const Text(
              editPostAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
            trailing: GestureDetector(
              onTap: (){
                if(titleController.text == ""){
                  showToast(feedTitleEmptyErrorText, gradientStart, gravity: ToastGravity.CENTER);
                  return;
                }
                if(contentController.text == ""){
                  showToast(postContentEmptyErrorText, gradientStart, gravity: ToastGravity.CENTER);
                  return;
                }
                if(locationController.text == ""){
                  showToast(locationEmptyErrorText, gradientStart, gravity: ToastGravity.CENTER);
                  return;
                }
                feedBloc.add(FeedEditEvent(
                  id: feedBloc.feedItem.id!,
                  title: titleController.text,
                  content: contentController.text,
                  tags: feedBloc.feedItem.tags.map((e) => e.tag ?? '').toList(),
                  location: locationController.text,
                  attaches: feedBloc.pickedFiles,
                  urls: feedBloc.pickedThumbnails
                ));
              },
              child: const SizedBox(
                width: 50,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    saveButtonText,
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
          body: BlocBuilder<FeedBloc, FeedState>(
            bloc: feedBloc,
            builder: (context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10,),
                        const SizedBox(height: 10,),
                        /// Title
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
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
                              controller: titleController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: primaryWhiteTextColor,
                                ),
                                hintText: postTitlePlaceholder,
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
                        /// Content
                        const SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            contentNode.requestFocus();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width - 10 * 2,
                            height: 200,
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
                                focusNode: contentNode,
                                controller: contentController,
                                cursorColor: primaryPlaceholderTextColor,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: primaryWhiteTextColor,
                                  ),
                                  hintText: postContentPlaceholder,
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
                        ),
                        /// Location
                        const SizedBox(height: 10,),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          padding: const EdgeInsets.only(right: 10),
                          width: MediaQuery.of(context).size.width - 10 * 2,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Stack(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                    // textSelectionHandleColor: Colors.transparent,
                                    primaryColor: Colors.transparent,
                                    scaffoldBackgroundColor:Colors.transparent,
                                    bottomAppBarColor: Colors.transparent
                                ),
                                child: TextField(
                                  controller: locationController,
                                  cursorColor: primaryPlaceholderTextColor,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: primaryWhiteTextColor,
                                    ),
                                    hintText: postLocationPlaceholder,
                                    prefixIcon: Icon(Icons.edit_location, color: primaryWhiteTextColor,),
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
                                      showToast(locationPermissionDeniedErrorText, gradientStart, gravity: ToastGravity.CENTER);
                                      return;
                                    }
                                  }

                                  _permissionGranted = await location.hasPermission();
                                  if (_permissionGranted == PermissionStatus.denied) {
                                    _permissionGranted = await location.requestPermission();
                                    if (_permissionGranted != PermissionStatus.granted) {
                                      showToast(locationPermissionDeniedErrorText, gradientStart, gravity: ToastGravity.CENTER);
                                      return;
                                    }
                                  }

                                  Position position = await Geolocator.getCurrentPosition();
                                  var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                                    create: (context) => FeedBloc(feedRepository: FeedRepository()),
                                    child: LocationScreen(position: position),
                                  )));
                                  if(result != null){
                                    double latitude = double.parse(result['lat']);
                                    double longitude = double.parse(result['lng']);
                                    final coordinates = Coordinates(latitude: latitude, longitude: longitude);
                                    try {
                                      GeoCode geoCode = GeoCode();
                                      Address address = await geoCode.reverseGeocoding(latitude: latitude, longitude: longitude);
                                      setState((){
                                        locationController.text = "${address.city}, ${address.countryName}";
                                      });
                                    }catch(exception) {}
                                  }
                                  
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width - 20,
                                  color: Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        ),
                        /// Tags
                        const SizedBox(height: 10,),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width - 10 * 2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Tags(
                              key: const Key("tag editor"),
                              symmetry: false,
                              columns: 0,
                              horizontalScroll: false,
                              verticalDirection:
                              VerticalDirection.down,
                              textDirection: TextDirection.ltr,
                              heightHorizontalScroll: 60 * (16 / 14),
                              textField: TagsTextField(
                                autofocus: false,
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: primaryWhiteTextColor
                                  //height: 1
                                ),
                                hintText: 'Add Tags',
                                hintTextColor: primaryWhiteTextColor,
                                width: MediaQuery.of(context).size.width - 40,
                                enabled: true,
                                constraintSuggestion: true,
                                suggestions: null,
                                onSubmitted: (String str) {
                                  setState(() {
                                    //_items.add(str);
                                    feedBloc.feedItem.tags.add(TagItem(tag: str));
                                  });
                                },
                              ),
                              itemCount: feedBloc.feedItem.tags.length,
                              itemBuilder: (index) {
                                final item = feedBloc.feedItem.tags[index];
                                return GestureDetector(
                                  child: ItemTags(
                                    key: Key(index.toString()),
                                    index: index,
                                    title: item.tag as String,
                                    pressEnabled: false,
                                    activeColor: gradientEnd.withOpacity(0.5),
                                    combine: combine,
                                    removeButton: ItemTagsRemoveButton(
                                      backgroundColor: Colors.transparent,
                                      onRemoved: () {
                                        setState(() {
                                          feedBloc.feedItem.tags.removeAt(index);
                                        });
                                        return true;
                                      },
                                    ),
                                    textScaleFactor:
                                    utf8.encode(item.tag!.substring(0, 1)).length > 2 ? 0.8 : 1,
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTapDown: (details) => _tapPosition = details.globalPosition,
                                );
                              }
                          ),
                        ),
                        
                        /// Media Container
                        const SizedBox(height: 10,),
                        state is FeedMediaFetchingState ?
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: MediaQuery.of(context).size.width * 0.3,
                          padding: feedBloc.pickedThumbnails.isNotEmpty ? const EdgeInsets.all(10) : const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              color: primaryWhiteTextColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ):
                        feedBloc.pickedThumbnails.isEmpty ?
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: MediaQuery.of(context).size.width * 0.3,
                          padding: feedBloc.pickedThumbnails.isNotEmpty ? const EdgeInsets.all(10) : const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              color: primaryWhiteTextColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Center(
                            child: Text(
                              'No Content',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryButtonFontSize
                              ),
                            ),
                          ),
                        )
                        :
                        state is FeedMediaFetchFailedState ?
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: MediaQuery.of(context).size.width * 0.3,
                          padding: feedBloc.pickedThumbnails.isNotEmpty ? const EdgeInsets.all(10) : const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              color: primaryWhiteTextColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Center(
                            child: Text(
                              'Getting Media Content Failed',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: primaryWhiteTextColor,
                                fontSize: primaryButtonFontSize
                              ),
                            ),
                          ),
                        ):
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          padding: feedBloc.feedItem.media.isNotEmpty ? const EdgeInsets.all(10) : const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              color: primaryWhiteTextColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 10.0,
                            runAlignment: WrapAlignment.start,
                            runSpacing: 10.0,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: feedBloc.pickedThumbnails.isNotEmpty ?
                            feedBloc.pickedThumbnails.map((file) {
                              int index = feedBloc.pickedThumbnails.indexOf(file);
                              return Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.width * 0.3 - 20,
                                    width: MediaQuery.of(context).size.width * 0.3 - 20,
                                    margin: const EdgeInsets.only(top: 10, right: 10),
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        /// if media is video, then render thumbnail
                                        file.type == 1 ? Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: FileImage(file.file!),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                        ):
                                        /// if media is image and file path is null, then render network image
                                        file.type == 0 && file.file == null ?
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: file.url!,
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
                                        ):
                                        /// if media is image and url is null, then render local image file
                                        file.type == 0 && file.file != null ?
                                        Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: FileImage(file.file!),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                        ):
                                        const SizedBox.shrink(),
                                        file.type == 0 ? const SizedBox.shrink(): Center(
                                          child: Icon(FontAwesomeIcons.playCircle, color: primaryWhiteTextColor.withOpacity(0.6), size: 40,),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        feedBloc.pickedThumbnails.removeAt(index);
                                        if(file.file != null){
                                          for(int i = 0; i < feedBloc.pickedFiles.length; i++){
                                            if(feedBloc.pickedFiles[i] == file.file){
                                              feedBloc.pickedFiles.removeAt(i);
                                            }
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.cancel, color: primaryWhiteTextColor,),
                                  )
                                ],
                              );
                            }).toList():
                            [],
                          ),
                        ),
                        const SizedBox(height: 20,)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: GestureDetector(
            onTap: (){
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      /// Take From Camera
                      CupertinoActionSheetAction(
                        child: const Text(
                          takePhotoText,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: primaryButtonFontSize
                          ),
                          textScaleFactor: 1.0,
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            /// Take Image
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                XFile? image = await ImagePicker().pickImage(
                                                    source: ImageSource.camera);
                                                if (image == null) return;
                                                setState(() {
                                                  feedBloc.pickedFiles.add(File(image.path));
                                                  feedBloc.thumbnails.add(File(image.path));
                                                  feedBloc.pickedThumbnails.add(MediaType(type: 0, file: File(image.path)));
                                                });
                                              },
                                              child: Container(
                                                width: createPostButtonWidth,
                                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                                decoration: BoxDecoration(
                                                  color: gradientStart.withOpacity(0.8),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Column(
                                                  children: const [
                                                    Icon(Icons.image, color: primaryWhiteTextColor, size: 17,),
                                                    SizedBox(height: 10,),
                                                    Text(
                                                      imagePickText,
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          color: primaryWhiteTextColor,
                                                          fontSize: createPostPopupFontSize
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            /// Take Video
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                XFile? video = await ImagePicker().pickImage(
                                                    source: ImageSource.camera);
                                                if (video == null) return;
                                                final thumbnail = await VideoThumbnail.thumbnailFile(
                                                  video: video.path,
                                                  imageFormat: ImageFormat.PNG,
                                                  maxWidth: 128,
                                                  quality: 25,
                                                );

                                                setState(() {
                                                  feedBloc.pickedFiles.add(File(video.path));
                                                  feedBloc.thumbnails.add(File(thumbnail!));
                                                  feedBloc.pickedThumbnails.add(MediaType(type: 1, file: File(thumbnail)));
                                                });
                                              },
                                              child: Container(
                                                width: createPostButtonWidth,
                                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                                decoration: BoxDecoration(
                                                  color: gradientStart.withOpacity(0.8),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Column(
                                                  children: const [
                                                    Icon(FontAwesomeIcons.video, color: primaryWhiteTextColor, size: 17,),
                                                    SizedBox(height: 10,),
                                                    Text(
                                                      videoPickText,
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          color: primaryWhiteTextColor,
                                                          fontSize: createPostPopupFontSize
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    onPressed: (){},
                                  )
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Icon(Icons.close, color: gradientStart,),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ),
                              )
                          );
                        },
                      ),
                      /// Take From Gallery
                      CupertinoActionSheetAction(
                        child: const Text(
                          chooseFromLibraryText,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: primaryButtonFontSize
                          ),
                          textScaleFactor: 1.0,
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            /// Pick Image
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                XFile? image = await ImagePicker().pickImage(
                                                    source: ImageSource.gallery);
                                                if(image == null) return;
                                                setState(() {
                                                  feedBloc.pickedFiles.add(File(image.path));
                                                  feedBloc.thumbnails.add(File(image.path));
                                                  feedBloc.pickedThumbnails.add(MediaType(type: 0, file: File(image.path)));
                                                });
                                              },
                                              child: Container(
                                                width: createPostButtonWidth,
                                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                                decoration: BoxDecoration(
                                                  color: gradientStart.withOpacity(0.8),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Column(
                                                  children: const [
                                                    Icon(Icons.image, color: primaryWhiteTextColor, size: 17,),
                                                    SizedBox(height: 10,),
                                                    Text(
                                                      imagePickText,
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          color: primaryWhiteTextColor,
                                                          fontSize: createPostPopupFontSize
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            /// Pick Video
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                XFile? video = await ImagePicker().pickImage(
                                                    source: ImageSource.gallery);
                                                if (video == null) return;
                                                final thumbnail = await VideoThumbnail.thumbnailFile(
                                                  video: video.path,
                                                  imageFormat: ImageFormat.PNG,
                                                  maxWidth: 128,
                                                  quality: 25,
                                                );

                                                setState(() {
                                                  feedBloc.pickedFiles.add(File(video.path));
                                                  feedBloc.thumbnails.add(File(thumbnail!));
                                                  feedBloc.pickedThumbnails.add(MediaType(type: 1, file: File(thumbnail)));
                                                });
                                              },
                                              child: Container(
                                                width: createPostButtonWidth,
                                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                                decoration: BoxDecoration(
                                                  color: gradientStart.withOpacity(0.8),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Column(
                                                  children: const [
                                                    Icon(FontAwesomeIcons.video, color: primaryWhiteTextColor, size: 17,),
                                                    SizedBox(height: 10,),
                                                    Text(
                                                      videoPickText,
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          color: primaryWhiteTextColor,
                                                          fontSize: createPostPopupFontSize
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    onPressed: (){},
                                  )
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Icon(Icons.close, color: gradientStart,),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ),
                              )
                          );
                          /*FilePickerResult result = await FilePicker.platform.pickFiles(
                              allowMultiple: true,
                              type: FileType.custom,
                              allowedExtensions: supportedMediaTypes
                          );
                          if(result != null) {
                            List<File> files = result.paths.map((path) => File(path)).toList();
                            for(int i = 0; i < files.length; i++){
                              String mimeType = mime(files[i].path);
                              if(imageMimeTypes.contains(mimeType)){
                                feedBloc.pickedThumbnails.add(MediaType(type: 0, file: files[i]));
                                feedBloc.thumbnails.add(files[i]);
                              }
                              else if(videoMimeTypes.contains(mimeType)){
                                final thumbnail = await VideoThumbnail.thumbnailFile(
                                  video: files[i].path,
                                  imageFormat: ImageFormat.PNG,
                                  maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                                  quality: 25,
                                );
                                feedBloc.thumbnails.add(File(thumbnail));
                                feedBloc.pickedThumbnails.add(MediaType(type: 1, file: File(thumbnail)));
                              }
                            }
                            setState(() {
                              feedBloc.pickedFiles.addAll(files);
                            });
                          }*/
                        },
                      )
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        cancelButtonText,
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
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2, right: MediaQuery.of(context).size.width * 0.2, bottom: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  color: gradientStart.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: primaryWhiteTextColor
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: primaryWhiteTextColor,),
                  SizedBox(width: 10,),
                  Text(
                    postMediaAddText,
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryWhiteTextColor,
                        fontSize: primaryButtonFontSize
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}