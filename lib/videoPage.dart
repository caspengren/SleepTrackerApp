import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class _PageSelectState extends State<PageSelect> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4ADFC),
      body: Center(
        // Center the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pressed = true;
                });
                // Navigate to YTVideoPlayer and play Video 1
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const YTVideoPlayer(videoId: 't0kACis_dJE'),
                  ),
                );
              },
              child: const Text("Sleep Facts"),
            ),
            const SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pressed = false;
                });
                // Navigate to YTVideoPlayer and play Video 2
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const YTVideoPlayer(videoId: 'cyEdZ23Cp1E'),
                  ),
                );
              },
              child: const Text("YOU NEED TO RELAX"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pressed = false;
                });
                // Navigate to YTVideoPlayer and play Video 2
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const YTVideoPlayer(videoId: 'dQw4w9WgXcQ'),
                  ),
                );
              },
              child: const Text("FUNNY"),
            ),
          ],
        ),
      ),
    );
  }
}
class PageSelect extends StatefulWidget {
  const PageSelect({super.key});

  @override
  State<PageSelect> createState() => _PageSelectState();
}

class YTVideoPlayer extends StatefulWidget {
  final String videoId;

  const YTVideoPlayer({super.key, required this.videoId});

  @override
  State<YTVideoPlayer> createState() => _YTVideoPlayerState();
}

class _YTVideoPlayerState extends State<YTVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      // Use the video ID passed via the constructor
      flags: YoutubePlayerFlags(
        autoPlay: true, // Set to true for auto-play
        mute: false,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YouTube Video")),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoView extends StatelessWidget {
  const VideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const PageSelect(), // Start with the PageSelect screen
    );
  }
}
