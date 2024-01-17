import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter1/main.dart';
import 'package:flutter1/screen/login_page.dart';

class VideoIntroScreen extends StatefulWidget {
  @override
  _VideoIntroScreenState createState() => _VideoIntroScreenState();
}

class _VideoIntroScreenState extends State<VideoIntroScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.asset('assets/loadingscreen.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      fullScreenByDefault: true,
      autoPlay: true,
      looping: false,
      autoInitialize: true, // Set autoInitialize to true
      showControls: false, // Hide the default controls
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.transparent,
        handleColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        bufferedColor: Colors.transparent,

      ),
      placeholder: Container(
        color: Colors.black,
      ),
    );

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position == _videoPlayerController.value.duration) {
        // Video finished, navigate to the HomeScreen or any other screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Chewie(controller: _chewieController),
      ),
    );
  }
}
