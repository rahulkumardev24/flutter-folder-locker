import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerScreen extends StatefulWidget {
  /// here we create constructor to get
  /// song current index , song list , video path
  String videoPath;
  int? currentSong;
  List<String>? musicList;
  VideoPlayerScreen({super.key,  required this.videoPath, this.currentSong, this.musicList});

  @override
  State<VideoPlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  int currentSong = 0;
  bool isVisible = true;
  bool isFullscreen = false;

  @override
  void initState() {
    super.initState();
    currentSong = widget.currentSong ?? 0;
    if (widget.videoPath != null) {
      _initializedVideoPlayer(widget.videoPath!);
    } else {
      print("Not Found");
    }
  }

  /// here we create function for _initializeVideoPlayer
  void _initializedVideoPlayer(String videoPath) {
    _videoPlayerController = VideoPlayerController.asset(videoPath)
      ..initialize().then((context) {
        setState(() {
          _videoPlayerController!.play();
          isVisible = false;
        });
      })
      ..addListener(() {
        setState(() {});
      });
  }

  /// here we create function for LANDSCAPE MODE TOGGLING
  void toggleFullscreen() {
    final bool wasPlaying = _videoPlayerController!.value.isPlaying;
    final Duration currentPosition = _videoPlayerController!.value.position;
    setState(() {
      if (isFullscreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
      isFullscreen = !isFullscreen;
    });
    if (wasPlaying) {
      _videoPlayerController!.play();
    } else {
      _videoPlayerController!.pause();
    }
    _videoPlayerController!.seekTo(currentPosition);
  }
  @override
  Widget build(BuildContext context) {
    bool isPlaying = _videoPlayerController?.value.isPlaying ?? false;
    return Scaffold(
      /// when full screen app bar is remove
      appBar: isFullscreen
          ? null
          : AppBar(
        title: const Text(
          "Video Nest",
          style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontFamily: "primary",
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/music.png",
            color: Colors.white,
          ),
        ),

        shadowColor: Colors.black,
        elevation: 11,
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      backgroundColor: Colors.blue.shade100,

      body: Center(
        child: _videoPlayerController != null &&
            _videoPlayerController!.value.isInitialized
            ? isFullscreen
            ? GestureDetector(
          onTap: () {
            setState(() {
              if (isPlaying) {
                isVisible = true;
              } else {
                isVisible = false;
              }
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                  aspectRatio:
                  _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!)),
              InkWell(
                  onTap: () {
                    setState(() {
                      if (isPlaying) {
                        _videoPlayerController!.pause();
                        isVisible = true;
                      } else {
                        _videoPlayerController!.play();
                        isVisible = false;
                      }
                    });
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: isVisible ? 1 : 0,
                    child: isPlaying
                        ? Image.asset(
                      "assets/icons/pause (2).png",
                      height: 40,
                      width: 40,
                    )
                        : Image.asset(
                      "assets/icons/play (2).png",
                      height: 40,
                      width: 40,
                    ),
                  )),

              /// Slider
              if (isVisible)
                Positioned(
                    bottom: 10,
                    left: 5,
                    right: 5,
                    child: AnimatedOpacity(
                      opacity: isVisible ? 1 : 0,
                      duration: const Duration(seconds: 1),
                      child: Slider(
                          value: _videoPlayerController!
                              .value.position.inSeconds
                              .toDouble(),
                          min: 0.0,
                          max: _videoPlayerController!
                              .value.duration.inSeconds
                              .toDouble(),
                          activeColor: Colors.blue.shade100,
                          thumbColor: Colors.blue.shade200,
                          inactiveColor: Colors.white38,
                          onChanged: (value) {
                            _videoPlayerController!.seekTo(
                                Duration(seconds: value.toInt()));
                          }),
                    )),

              /// full screen icon

              if (isVisible)
                Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(

                      /// here we apply logic for full screen (LANDSCAPE MODE)
                        onTap: () {
                          /// here we call toggle fullScreen function
                          toggleFullscreen();
                          setState(() {});
                        },
                        child: isFullscreen
                            ? Icon(
                          Icons.fullscreen,
                          color: Colors.white.withOpacity(0.9),
                          size: 30,
                        )
                            : Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white.withOpacity(0.9),
                          size: 30,
                        )))
            ],

            /// this part is portrait mode
          ),
        )
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// here we show video
              Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                      aspectRatio:
                      _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!)),
                  InkWell(
                      onTap: () {
                        setState(() {
                          if (isPlaying) {
                            _videoPlayerController!.pause();
                            isVisible = true;
                          } else {
                            _videoPlayerController!.play();
                            isVisible = false;
                          }
                        });
                      },
                      child: AnimatedOpacity(
                        duration: const Duration(seconds: 1),
                        opacity: isVisible ? 1 : 0,
                        child: isPlaying
                            ? Image.asset(
                          "assets/icons/pause (2).png",
                          height: 40,
                          width: 40,
                        )
                            : Image.asset(
                          "assets/icons/play (2).png",
                          height: 40,
                          width: 40,
                        ),
                      )),

                  /// Slider
                  Positioned(
                      bottom: 10,
                      left: 5,
                      right: 5,
                      child: Slider(
                          value: _videoPlayerController!
                              .value.position.inSeconds
                              .toDouble(),
                          min: 0.0,
                          max: _videoPlayerController!
                              .value.duration.inSeconds
                              .toDouble(),
                          activeColor: Colors.blue.shade100,
                          thumbColor: Colors.blue.shade200,
                          inactiveColor: Colors.white38,
                          onChanged: (value) {
                            _videoPlayerController!.seekTo(
                                Duration(seconds: value.toInt()));
                          })),

                  /// full screen icon
                  Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(

                        /// here we apply logic for full screen (LANDSCAPE MODE)
                          onTap: () {
                            toggleFullscreen();
                          },
                          child: isFullscreen
                              ? Icon(
                            Icons.fullscreen_exit,
                            color:
                            Colors.white.withOpacity(0.9),
                            size: 30,
                          )
                              : Icon(
                            Icons.fullscreen,
                            color:
                            Colors.white.withOpacity(0.9),
                            size: 30,
                          )))
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// left
                  /// previous song => Done
                  InkWell(
                    /// here we apply logic
                    onTap: () {
                      setState(() {
                        if (currentSong > 0) {
                          currentSong++;
                          _initializedVideoPlayer(
                              widget.musicList![currentSong]);
                        }
                      });
                    },
                    child: Image.asset(
                      "assets/icons/chevron-left.png",
                      height: 50,
                      width: 50,
                    ),
                  ),

                  /// play and pause
                  InkWell(
                    onTap: () {
                      if (isPlaying) {
                        _videoPlayerController!.pause();
                      } else {
                        _videoPlayerController!.play();
                      }
                    },
                    child: isPlaying
                        ? Image.asset(
                      "assets/icons/pause (3).png",
                      height: 50,
                      width: 50,
                    )
                        : Image.asset(
                      "assets/icons/play (2).png",
                      height: 50,
                      width: 50,
                    ),
                  ),

                  /// right
                  InkWell(
                    /// here we apply logic for next song
                    onTap: () {
                      if (currentSong <
                          (widget.musicList?.length ?? 0) - 1) {
                        setState(() {
                          currentSong++;
                          _initializedVideoPlayer(
                              widget.musicList![currentSong]);
                        });
                      }
                    },
                    child: Image.asset(
                      "assets/icons/chevron-right.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

/// apply play and pause => DONE
/// Hide and UnHide Play pause button => DONE
/// Slider => DONE
/// next and previous song => DONE
/// when click on player icon default music play index 0 => DONE
/// last step video playing in LANDSCAPE MODE => DONE
/// simple Problem when in full screen mode pause and play button are visible => DONE
/// Slider is also hide => DONE
/// check the code =>
