import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../widgets/my_navigation_button.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  VideoPlayerScreen({required this.videoPath, Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    File file = File(widget.videoPath);

    if (await file.exists()) {
      _videoPlayerController = VideoPlayerController.file(file);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        fullScreenByDefault: true,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
      );

      setState(() {});
    } else {
      print("Error: File does not exist at ${widget.videoPath}");
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7E7DC),
      appBar: AppBar(
        backgroundColor: Color(0xffF7E7DC),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyNavigationButton(
            btnIcon: Icons.backspace_outlined,
            iconSize: 23,
            iconColor: Color(0xff405D72),
            btnBackground: Colors.black12,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.delete, size: 27, color: Color(0xff405D72)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.lock_open_outlined,
              size: 27,
              color: Color(0xff405D72),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.share, size: 27, color: Color(0xff405D72)),
          ),
        ],
      ),

      body:
          _chewieController != null &&
                  _videoPlayerController.value.isInitialized
              ? Chewie(controller: _chewieController!)
              : const Center(
                child: Text(
                  "Video not found!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
    );
  }
}
