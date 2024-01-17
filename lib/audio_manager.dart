import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class BackgroundMusic extends StatefulWidget {
  @override
  _BackgroundMusicState createState() => _BackgroundMusicState();
}

class _BackgroundMusicState extends State<BackgroundMusic> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() async {
    await audioPlayer.setSource(AssetSource("assets/audio/avirensong.mp3"));
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.play(AssetSource("assets/audio/avirensong.mp3")).then((value) {
      setState(() {
        playerState = PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}