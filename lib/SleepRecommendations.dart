import 'package:flutter/material.dart';

class SleepRecommendations {

  int whenSleep(DateTime time){
    int newTime;
    if (time.hour - 8 <= 0 ){
      newTime = 24 + time.hour - 8;
      if (newTime == 24) {
        return 0;
      }
      return newTime;
    } else {
      return time.hour - 8;
    }
  }

  int whenWake(DateTime time) {
    if (time.hour + 8 <= 23) {
      return time.hour + 8;
    } else {
      return time.hour - 24 + 8;
    }
  }
}

