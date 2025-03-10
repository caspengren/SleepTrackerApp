import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'playPauseButton.dart'; // Make sure this file exists in your project



class musicselect extends StatefulWidget {
  const musicselect({super.key});

 // final String title;

  @override
  State<musicselect> createState() => _musicselect();
}

class _musicselect extends State<musicselect> {
  final AudioPlayer player = AudioPlayer();
  late Uint8List audioBytes;
  int currentPos = 0;
  int maxDuration = 10;
  bool isPlaying=false;

  @override
  void initState() {
    super.initState();

    // Initialize audio player events
    player.onDurationChanged.listen((Duration d) {
      setState(() {
        maxDuration = d.inSeconds;
      });
    });

    player.onPositionChanged.listen((Duration p) {
      setState(() {
        currentPos = p.inSeconds;
      });
    });
    player.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> loadAudio(String assetPath) async {
    ByteData bytes = await rootBundle.load(assetPath);
    audioBytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  Future<void> playMusic(String assetPath) async {
    await loadAudio(assetPath);
    await player.stop(); // Stop any currently playing audio
    await player.play(BytesSource(audioBytes));
  }

  void playMusicOne() {
    playMusic("assets/asmr/fallAsleepInThreeMins.mp3");
  }

  void playMusicTwo() {
    playMusic("assets/asmr/fallAsleepInTen.mp3");
  }

  void playMusicThree() {
    playMusic("assets/music/lofiFor30.mp3");
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4ADFC),
      //appBar: AppBar(
        //title: Text(widget.title),
      //),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(5),
              children: <Widget>[
                _buildButton("ASMR Video Crunching", playMusicOne),
                _buildButton("ASMR FALL ASLEEP IN TEN", playMusicTwo),
                _buildButton("lofi for 30 mins", playMusicThree),

              ],
            ),
          ),
          Audioplaybar(
            onPlayStateChanged: (value) async {
              if (value) {
                if (isPlaying) {
                  await player.pause();
                } else {
                  await player.resume();
                }
              } else {
                await player.stop();
              }
            },
            currentTime: Duration(seconds: currentPos),
            onSeekBarMoved: (value) {},
            totalTime: Duration(seconds: maxDuration),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      height: 50,
      color: Colors.amber[500],
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
