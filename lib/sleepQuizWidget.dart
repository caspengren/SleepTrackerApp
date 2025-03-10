import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dailyQuiz.dart';

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
      title: 'Daily Sleep Quiz',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const DailySleepQuizPage(title: 'Flutter Survey'),
    );
  }
}

class DailySleepQuizPage extends StatefulWidget {
  const DailySleepQuizPage({super.key, required this.title});

  final String title;

  @override
  State<DailySleepQuizPage> createState() => _DailySleepQuizPageState();
}

class _DailySleepQuizPageState extends State<DailySleepQuizPage> {
  final databaseReference = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String? _quizID;
  List<QuestionResult> questionResults = [];
  final List<Question> _initialData = sleepQuiz;

  Future<void> sendQuiz(List<QuestionResult>questionResults) async {
    DocumentReference quizDoc = await databaseReference.collection('dailysleepquiz').add({
      'sleepquality' : null,
      'sleepinterruptions' : null,
    });

    setState(() {
      _quizID = quizDoc.id;
      //print(_answersID);
    });

      for (var i = 0; i < questionResults.length; i++) {
        var currentElement = questionResults[i].answers.first;
        switch (i) {
          case 0:
            databaseReference.collection('dailysleepquiz')
                .doc(_quizID)
                .update({
              'sleepquality': currentElement,
            });
            break;
          case 1:
            databaseReference.collection('dailysleepquiz')
                .doc(_quizID)
                .update({
              'sleepinterruptions': currentElement,
            });
            break;

            /*
          case 2:
            databaseReference.collection('dailysleepquiz')
                .doc(_quizID)
                .update({
              'sleepinterruptionscause': currentElement.,
            });
            break;
             */
        // Don't send cause of interruptions, just store that there
        // were sleep interruptions.
        }
        //print(currentElement);
      }
      return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD4ADFC),
      appBar: AppBar(
        title: const Text('Daily Sleep Quiz'),
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

