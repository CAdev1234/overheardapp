// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class CustomVideoPlayer extends StatefulWidget {
//   @override
//   CustomVideoPlayerState createState() => CustomVideoPlayerState();
// }

// class CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   late VideoPlayerController _controller;
  
//   @override
//   void initState() {
//     super.initState();
//     final controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
//     _controller = controller;
//     setState(() {   
//     });
//     controller..initialize().then((_) {
//       controller.play();
//       setState(() {        
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: _controller.value.isInitialized ? AspectRatio(
//         aspectRatio: _controller.value.aspectRatio,
//         child: VideoPlayer(_controller),
//       )
//       :
//       Container(),
//     );
//   }
// }