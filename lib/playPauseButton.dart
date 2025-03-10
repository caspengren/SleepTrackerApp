import 'package:flutter/material.dart';
import 'dart:ui';

class Audioplaybar extends StatefulWidget {
  Audioplaybar({
    Key? key,
    this.isPlaying = false,
    required this.onPlayStateChanged,
    required this.currentTime,
    required this.onSeekBarMoved,
    required this.totalTime,
  }) : super(key: key);
  bool isPlaying;
  final ValueChanged<bool> onPlayStateChanged;
  final Duration currentTime;
  final ValueChanged<Duration> onSeekBarMoved;
  final Duration totalTime;

  @override
  State<Audioplaybar> createState() => _AudioplaybarState();
} //end of AudioPlayBar

class _AudioplaybarState extends State<Audioplaybar> {
  double sliderValue = 0;

  bool userIsMovingSlider = false;

  @override
  void initState() {
    super.initState();
    sliderValue = getSliderValue();
    userIsMovingSlider = false;
  }

  //vars and initstate always needs to be at the top

  IconButton playPauseButton() {
    return IconButton(
        icon: (widget.isPlaying) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        color: Color.fromARGB(225, 16, 16, 214),
        onPressed: () {
          if(widget.onPlayStateChanged != null){
            widget.onPlayStateChanged(!widget.isPlaying);
            widget.isPlaying = !widget.isPlaying;
          }
        });// onpress
  }


  Slider buildSlider(BuildContext context) {
    return Slider(
        value: sliderValue,
        inactiveColor: Theme
            .of(context)
            .disabledColor,
        //1
        onChangeStart: (value) {
          userIsMovingSlider = true;
        },
        //2
        onChanged: (value) {
          setState(() {
            sliderValue = value;
          });
        },
        //3
        onChangeEnd: (value) {
          userIsMovingSlider = false;
          if (widget.onSeekBarMoved != null) {
            final seconds = widget.totalTime.inSeconds * sliderValue;
            final currentTime = Duration(seconds: seconds.toInt());
            widget.onSeekBarMoved(currentTime);
          }
        }
    ); // end of slider
  }

  double getSliderValue() {
    return widget.currentTime.inMilliseconds / widget.totalTime.inMilliseconds;
  }

  String getTimeString(double sliderValue) {
    final secondsAmount = widget.totalTime.inSeconds * sliderValue;
    final time = Duration(seconds: secondsAmount.toInt());
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }
    final minutes =
    twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));
    final seconds =
    twoDigits(time.inSeconds.remainder(Duration.secondsPerMinute));
    final hours = widget.totalTime.inHours > 0 ? '${time.inHours}:' : '';
    return "$hours$minutes:$seconds";
  } // end getTimeString

  @override //build needs to stay at the bottom
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          playPauseButton(),
          Text(
            getTimeString(sliderValue),
            style: TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          Expanded(child: buildSlider(context)),
          Text(
            getTimeString(1.0),
          ),
        ],
      ),
    );
  } // end of build
} // end of _AudioplaybarState

