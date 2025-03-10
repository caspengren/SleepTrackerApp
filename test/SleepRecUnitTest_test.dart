import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_number_h/SleepRecommendations.dart';


void main() {
  SleepRecommendations sleepRecommendations = SleepRecommendations();


test('Test 1', () {

  final int whenSleep = sleepRecommendations.whenSleep(DateTime(2017, 9, 7, 17));

expect(whenSleep, 9);});

test('Test 2', () {

  final int whenSleep2 = sleepRecommendations.whenSleep(DateTime(2017, 9, 7, 4, 30));

  expect(whenSleep2, 20);});

}









