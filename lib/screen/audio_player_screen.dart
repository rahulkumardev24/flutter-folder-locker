import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:password_lock_shared_pre/utils/custom_text_style.dart';
import 'package:password_lock_shared_pre/widgets/my_navigation_button.dart';

class PlayerScreen extends StatefulWidget {
  String songPath;
  PlayerScreen({super.key, required this.songPath});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool isPlaying = false;
  bool isSuf = false;
  bool isRepeat = false;

  final AudioPlayer audioPlayer = AudioPlayer();
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    /// Listen to the position updates
    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });

    /// Listen to total duration of song
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });

    /// Automatically play the next song when current song ends
    audioPlayer.onPlayerComplete.listen((event) {
      if (!isRepeat) {
        // Call nextSong() if shuffle is off
        // nextSong();
      }
    });
  }

  /// Function to play or pause audio
  Future<void> myAudioPlay() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(widget.songPath));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  /// Function to seek to a specific position
  Future<void> seekChange(double seconds) async {
    await audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  /// Format Duration
  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return "$minutes:$seconds";
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
            child: Icon(Icons.delete ,  size: 27, color: Color(0xff405D72), ),
          ) ,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.lock_open_outlined , size: 27, color: Color(0xff405D72),),
          ) ,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.share , size: 27, color: Color(0xff405D72),),
          ) ,
        ],
      ),
      body: Center(
        child: Column(
          children: [
            /// LOTTIE ANIMATION SHOW
            LottieBuilder.asset("assets/animation/playeranim.json"),

            const SizedBox(height: 10),

            /// MUSIC NAME SHOW
            SizedBox(
              height: 30,
              child: Marquee(
                blankSpace: 50,
                startPadding: 10,
                velocity: 30,
                style: myTextStyle21(),
                text: widget.songPath.split('/').last,
              ),
            ),

            const Spacer(),

            /// BOTTOM CONTROLS
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Color(0xff405D72),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// Shuffle & Repeat Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Shuffle Button
                        InkWell(
                          onTap: () {
                            setState(() {
                              isSuf = !isSuf;
                            });
                          },
                          child:
                              isSuf
                                  ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Image.asset(
                                        "assets/icons/suffle.png",
                                        height: 30,
                                      ),
                                    ),
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset(
                                      "assets/icons/suffle.png",
                                      height: 30,
                                    ),
                                  ),
                        ),

                        /// Repeat Button
                        InkWell(
                          onTap: () {
                            setState(() {
                              isRepeat = !isRepeat;
                              audioPlayer.setReleaseMode(
                                isRepeat ? ReleaseMode.loop : ReleaseMode.stop,
                              );
                            });
                          },
                          child:
                              isRepeat
                                  ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Image.asset(
                                        "assets/icons/rotate.png",
                                        height: 30,
                                      ),
                                    ),
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset(
                                      "assets/icons/rotate.png",
                                      height: 30,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),

                  /// ------------------------ SLIDER ---------------------------
                  Slider(
                    value: currentPosition.inSeconds.toDouble(),
                    min: 0.0,
                    max:
                        totalDuration.inSeconds > 0
                            ? totalDuration.inSeconds.toDouble()
                            : 1.0,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.white38,
                    onChanged: (value) {
                      setState(() {
                        seekChange(value);
                      });
                    },
                  ),

                  /// DURATION SHOW
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDuration(currentPosition),
                          style: myTextStyle15(),
                        ),
                        Text(
                          formatDuration(totalDuration),
                          style: myTextStyle15(),
                        ),
                      ],
                    ),
                  ),

                  /// CONTROLS (Previous, Play/Pause, Next)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.skip_previous,
                            size: 40,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            // previousSong();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 50,
                            color: Colors.white70,
                          ),
                          onPressed: myAudioPlay,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.skip_next,
                            size: 40,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            // nextSong();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
}
