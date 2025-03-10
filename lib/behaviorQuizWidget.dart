import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'behaviorQuiz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCV5ZuILuQC0XKohaEDjzMX_f_8eit_wnA",
      appId: "1:723390560267:android:afa6ffde1a5bfccb35af0e",
      messagingSenderId: "723390560267",
      projectId: "sleep-time-log",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Quiz',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const BehaviorQuizPage(title: 'Flutter Survey'),
    );
  }
}

class BehaviorQuizPage extends StatefulWidget {
  const BehaviorQuizPage({super.key, required this.title});

  final String title;

  @override
  State<BehaviorQuizPage> createState() => _BehaviorQuizPageState();
}

class _BehaviorQuizPageState extends State<BehaviorQuizPage> {
  final databaseReference = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String? _answersID;
  String _scoreID = "AWWoIMLO0YKW8YhNBys5";
  List<QuestionResult> questionResults = [];
  final List<Question> _initialData = behaviorQuiz;

  String formatResults(questionResults) {
    String formattedResults = questionResults.toString();
    formattedResults = formattedResults.replaceAll("QuestionResult", "").replaceAll("[", "").replaceAll("]", "").replaceAll("(", " ").replaceAll(")", " ");
    return formattedResults;
  }

  /*
  void sendQuiz(questionResults) async {
    //databaseReference.push().set({formatResults(questionResults)});
    databaseReference.push().set("Behavior Quiz: " + formatResults(questionResults));
  }
   */

  int getNumericalValue (String answer) {
    switch (answer) {
      case "No caffeine":
        return 10;
      case "1-100 mg":
        return 8;
      case "101-200 mg":
        return 6;
      case "201-300 mg":
        return 5;
      case "301-400 mg":
        return 4;
      case "401-500 mg":
        return 2;
      case "501+ mg":
        return 0;
      case "No alcoholic drinks":
        return 10;
      case "1-2 drinks":
        return 8;
      case "3-4 drinks":
        return 5;
      case "4-5 drinks":
        return 3;
      case "6+ drinks":
        return 0;
      case "No screen time":
        return 10;
      case "Less than 1 hour":
        return 9;
      case "1-2 hours":
        return 8;
      case "2-3 hours":
        return 7;
      case "4-5 hours":
        return 6;
      case "6+ hours":
        return 4;
      case "No meals":
        return 0;
      case "1 meal":
        return 5;
      case "2 meals":
        return 9;
      case "3 meals":
        return 10;
      case "No plain water":
        return 0;
      case "<1000 mL":
        return 2;
      case "1001-2000 mL":
        return 4;
      case "2001-3000 mL":
        return 8;
      case "3001-4000 mL":
        return 10;
      case "4001+ mL":
        return 10;
      case "no":
      case "yes":
        return 0;
        //From elliot and baxter with love (I'm sorry)
    }
    return 0;
  }

  Future<void> sendQuiz(List<QuestionResult>questionResults) async {
    DocumentReference quizDoc = await databaseReference.collection('behaviorquiz').add({
      'caffeine' : null,
      'alcohol' : null,
      'screentime' : null,
      'meals' : null,
      'water' : null,
      'nap' : null,
    });

    setState(() {
      _answersID = quizDoc.id;
      //print(_answersID);
    });

    DocumentSnapshot scoreDoc = await databaseReference.collection('behaviorquizscores').doc(_scoreID).get();

    if (scoreDoc.exists) {
      int caffeineScore = (scoreDoc['caffeinescore']) as int;
      int alcoholScore = (scoreDoc['alcoholscore']) as int;
      int screenTimeScore = (scoreDoc['screentimescore']) as int;
      int mealScore = (scoreDoc['mealscore']) as int;
      int waterScore = (scoreDoc['waterscore']) as int;
      int napScore = (scoreDoc['napscore']) as int;

      int behaviorsScore = (scoreDoc['totalscore']) as int;
      int totalSubmissions = (scoreDoc['totalsubmissions']) as int;

      for (var i = 0; i < questionResults.length; i++) {
        var currentElement = questionResults[i].answers.first;
        switch (i) {
          case 0:
            databaseReference.collection('behaviorquiz')
                .doc(_answersID)
                .update({
              'caffeine': currentElement,
            });
            databaseReference.collection('behaviorquizscores').doc(_scoreID).update({
              'caffeinescore': caffeineScore + getNumericalValue(currentElement),
              'totalscore': behaviorsScore + getNumericalValue(currentElement),
            });
            break;
          case 1:
            databaseReference.collection('behaviorquiz')
                .doc(_answersID)
                .update({
              'alcohol': currentElement,
            });
            databaseReference.collection('behaviorquizscores').doc(_scoreID).update({
              'alcoholscore': alcoholScore + getNumericalValue(currentElement),
              'totalscore': behaviorsScore + getNumericalValue(currentElement),
            });
            break;
          case 2:
            databaseReference.collection('behaviorquiz')
                .doc(_answersID)
                .update({
              'screentime': currentElement,
            });
            databaseReference.collection('behaviorquizscores').doc(_scoreID).update({
              'screentimescore': screenTimeScore + getNumericalValue(currentElement),
              'totalscore': behaviorsScore + getNumericalValue(currentElement),
            });
            break;
          case 3:
            databaseReference.collection('behaviorquiz')
                .doc(_answersID)
                .update({
              'meals': currentElement,
            });
            databaseReference.collection('behaviorquizscores').doc(_scoreID).update({
              'mealscore': mealScore + getNumericalValue(currentElement),
              'totalscore': behaviorsScore + getNumericalValue(currentElement),
            });
            break;
          case 4:
            databaseReference.collection('behaviorquiz')
                .doc(_answersID)
                .update({
              'water': currentElement,
            });
            databaseReference.collection('behaviorquizscores').doc(_scoreID).update({
              'waterscore': waterScore + getNumericalValue(currentElement),
              'totalscore': behaviorsScore + getNumericalValue(currentElement),
            });
            break;
          case 5:
            databaseReference.collection('behaviorquiz')
                .doc(_answersID)
                .update({
              'nap': currentElement,
            });
            databaseReference.collection('behaviorquizscores').doc(_scoreID).update({
              'napscore': napScore + getNumericalValue(currentElement),
              'totalscore': behaviorsScore + getNumericalValue(currentElement),
            });
            break;
        }
        //print(currentElement);
      }
      databaseReference.collection('behaviorquizscores').doc(_scoreID).update({
        'totalsubmissions': totalSubmissions + 1,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD4ADFC),
      appBar: AppBar(
        title: const Text('Behavior Quiz'),
        centerTitle: true,
        backgroundColor: Color(0xFF5C469C),
      ),
      body: Form(
        key: _formKey,
        child: Survey(
            onNext: (collectedQuestionResults) {
              questionResults = collectedQuestionResults;
              print(questionResults);
            },
            initialData: _initialData),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF5C469C), // Background Color
              ),
              child: const Text("Submit"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  //do something
                  sendQuiz(questionResults);

                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
