import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import "behaviorQuizWidget.dart";
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const DailyReflectionAveragePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class theNumbers {
  final databaseReference = FirebaseFirestore.instance;
  String _scoreID = "AWWoIMLO0YKW8YhNBys5";

  double caffeinescore = 0;
  double alcoholscore = 0;
  double screentimescore = 0;
  double mealscore = 0;
  double waterscore = 0;

  Future<double> getScoreFromDB(String scoreTitle) async {
    DocumentSnapshot scoreDoc = await databaseReference.collection(
        'behaviorquizscores').doc(_scoreID).get();

    switch (scoreTitle) {
      case 'caffeinescore':
        double caffeineScore = await (scoreDoc['caffeinescore']) as double;
        return caffeineScore;
      case 'alcoholscore':
        double alcoholScore = await (scoreDoc['alcoholscore']) as double;
        return alcoholScore;
      case 'screenTimeScore':
        double screenTimeScore = await (scoreDoc['screentimescore']) as double;
        return screenTimeScore;
      case 'mealscore':
        double mealScore = await (scoreDoc['mealscore']) as double;
        return mealScore;
      case 'waterscore':
        double waterScore = await (scoreDoc['waterscore']) as double;
        return waterScore;
      case 'napscore':
        double napScore = await (scoreDoc['napscore']) as double;
        return napScore;
    }
    return 0; //shouldnt happen ¯\_(ツ)_/¯

  }

  void setCafScore() async {
    caffeinescore = await getScoreFromDB('caffeinescore');
  }
  void setAlcScore() async {
    alcoholscore = await getScoreFromDB('alcoholscore');
  }
  void setSTScore() async {
    screentimescore = await getScoreFromDB('screentimescore');
  }
  void setMealScore() async {
    mealscore = await getScoreFromDB('mealscore');
  }
  void setWaterScore() async {
    waterscore = await getScoreFromDB('waterscore');
  }

}

class DailyReflectionAveragePage extends StatefulWidget {
  const DailyReflectionAveragePage({super.key, required this.title});

  final String title;

  @override
  State<DailyReflectionAveragePage> createState() => _DailyReflectionAveragePage();
}
class _DailyReflectionAveragePage extends State<DailyReflectionAveragePage> {





  @override
  Widget build (BuildContext context) {


  Widget chartToRun() {

    theNumbers scores = theNumbers();
    scores.setCafScore();
    scores.setAlcScore();
    scores.setSTScore();
    scores.setMealScore();
    scores.setWaterScore();


    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
      ChartData chartData;
      ChartOptions chartOptions = const ChartOptions();
      chartData = ChartData(
        dataRows:  [
          [scores.caffeinescore, scores.alcoholscore, scores.screentimescore, scores.mealscore, scores.waterscore],
          [0.0, 0.0, 0.0, 0.0, 0.0]
        ],
        xUserLabels: const ['caffeine', 'alcohol', 'screen time', 'meal', 'water'],
        dataRowsLegends: const [
          '',
          '',
        ],
        chartOptions: chartOptions,
      );

      var verticalBarChartContainer = VerticalBarChartTopContainer(
        chartData: chartData,
        xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
      );

      var verticalBarChart = VerticalBarChart(
        painter: VerticalBarChartPainter(
          verticalBarChartContainer: verticalBarChartContainer,
        ),
      );
      return verticalBarChart;
    }


    return Scaffold(
      backgroundColor: const Color(0xFFD4ADFC),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: const Color(0xFFD4ADFC),
      ),

      body: Center(
        child: Column(
            children: <Widget>[
              Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('>>>'),
                  Expanded(
                    // #### Core chart
                    child: chartToRun(), // barChart, lineChart
                  ),
                  const Text('<<'),
                ],
              ),
              ),
          ],
        )
      ),
    );
  }



}


