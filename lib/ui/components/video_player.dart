import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


class CustomCachedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  const CustomCachedVideoPlayer({Key? key, 
    required this.videoUrl, 
    required this.autoPlay
  }): assert(videoUrl != null), super(key: key);

  @override
  CustomCachedVideoPlayerState createState() => CustomCachedVideoPlayerState();
}

class CustomCachedVideoPlayerState extends State<CustomCachedVideoPlayer> {

  late VideoPlayerController  controller;
  final bool _isPlayerReady = false;

  @override
  void initState() {
    controller = VideoPlayerController.network(
        widget.videoUrl);
    controller.initialize().then((_) {
      setState(() {});
      //controller.play();
    });
    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void playVideo(){
    if(_isPlayerReady != null){
      controller.play();
    }
  }

  Future<String?> getThumbnail() async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: widget.videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128,
      quality: 25,
    );
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Center(
            child: controller.value != null && controller.value.isInitialized ?
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  child: VideoPlayer(controller),
                  aspectRatio: controller.value.aspectRatio,
                ),
                controller.value.isPlaying ?
                const SizedBox.shrink():
                ControlsOverlay(controller: controller)
              ],
            ):
            const Center(
              child: CupertinoActivityIndicator(),
            )
        )
    );
  }
}

class ControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  const ControlsOverlay({Key? key, required this.controller}) : super(key: key);
  @override
  ControlsOverlayState createState() {
    return ControlsOverlayState();
  }

}

class ControlsOverlayState extends State<ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.transparent,
            child: Center(
              child: Icon(Icons.play_circle, color: primaryWhiteTextColor.withOpacity(0.6), size: 60,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
            setState(() {

            });
          },
        ),
      ],
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller}) : super(key: key);
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}