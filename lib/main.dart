//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_number_h/playPauseScreen.dart';
import 'package:flutter/services.dart';
import 'package:group_number_h/videoPage.dart';
import 'package:group_number_h/dailyReflectionWidget.dart';
import 'package:group_number_h/sleepQuizWidget.dart';
import 'package:group_number_h/behaviorQuizWidget.dart';
import 'package:group_number_h/averageScoreBehaviorQuizGUI.dart';
import 'package:group_number_h/sleepTime.dart';
import 'package:group_number_h/wakeUpTime.dart';
import 'dreamJournal.dart';
import 'package:rive/rive.dart' as rive;

// hey gang

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // check for errors
          if (snapshot.hasError) {
            print("couldn't connect, please try again");
          }
          // once we check for errors, then show app
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp (
              debugShowCheckedModeBanner: false,
              title: 'sleep app',
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
              ),
              home: const MyHomePage(title: 'sleep app!'),
            );
          }
          Widget loading = MaterialApp();
          return loading;
        });
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////

class _MyHomePageState extends State<MyHomePage> {

  String? _documentID;
  final databaseRef = FirebaseFirestore.instance;
  int selectedIndex = 0;

  /////////////////////////////////////////
  // home page button functions

  // record start sleep time
  Future<void> startSleep() async {
    try {
      DateTime now = DateTime.now();
      print("attempting to add sleep record to FireStore");

      DocumentReference doc = await databaseRef.collection('sleeptime').add({
        'startSleep': now,
        'wakeUp': null,
        'hoursSlept': null,
      });
      setState(() {
        // save doc id
        _documentID = doc.id;
        print("document id saved: $_documentID");
      });
      print("start sleep recorded: $now");

      playSleepAnimation('Timeline 1');
    } catch (error) {
      print("error recording start sleep time: $error");
    }

  }

  // record wake-up time
  Future<void> wakeUp() async {
    setState(() {
      showSleepMessage = false;
    });
    if (_documentID == null) {
      print("no sleep record found. you must record sleep start time first.");
      return;
    }
    DateTime now = DateTime.now();
    await databaseRef.collection('sleeptime').doc(_documentID).update({
      'wakeUp': now,
    });
    print("wake up time recorded: $now");

    playSleepAnimation('Timeline 2');
  }

  // variables needed for calculateHoursSlept
  double? hoursSlept;
  String? sleepMessage;
  bool showSleepMessage = false;

  // calculate hours slept
  Future<void> calculateHoursSlept() async {
    if (_documentID == null) {
      print(
          "no sleep record found. you must record a start sleep and wake up time before we"
              "can calculate how long you slept.");
      return;
    }
    DocumentSnapshot doc = await databaseRef.collection('sleeptime').doc(
        _documentID).get();
    if (doc.exists) {
      DateTime? startSleep = (doc['startSleep'] as Timestamp).toDate();
      DateTime? wakeUp = doc['wakeUp'] != null ? (doc['wakeUp'] as Timestamp)
          .toDate() : null;

      if (startSleep != null && wakeUp != null) {
        Duration duration = wakeUp.difference(startSleep);
        double calcHoursSlept = duration.inMinutes / 60;
        // round number of hours slept to 2 decimal points
        double roundedHoursSlept = double.parse(
            calcHoursSlept.toStringAsFixed(2));

        // check to see if hours slept is within recommended range
        String? calculatedSleepMessage;
        if (roundedHoursSlept >= 7 && roundedHoursSlept <= 9) {
          calculatedSleepMessage =
          "nice! between 7 and 9 hours of sleep is a healthy amount of sleep";
        } else if (roundedHoursSlept < 7) {
          calculatedSleepMessage =
          "you should aim to get at least 7 hours of sleep a night!";
        } else {
          calculatedSleepMessage =
          "you may be oversleeping! 7-9 hours is the ideal amount of sleep a night";
        }

        // update database with new sleep hours calculation
        await databaseRef.collection('sleeptime').doc(_documentID).update({
          'hoursSlept': roundedHoursSlept,
        });
        print("you slept for $roundedHoursSlept hours");

        // update UI to display hours slept
        setState(() {
          hoursSlept = roundedHoursSlept;
          sleepMessage = calculatedSleepMessage;
          showSleepMessage = true;
        });
      } else {
        print(
            "sorry, we don't have enough data to calculate how long you slept!");
      }
    }
  }

  //////////////////////////////////////////////////////////
  late rive.Artboard? _riveArtboard;
  late rive.RiveAnimationController? _controller;

  void _loadRiveFile() {
    rootBundle.load('assets/animations/sleepwakeanimate.riv').then((data) {
      final file = rive.RiveFile.import(data);
      final artboard = file.mainArtboard;

      // set the artboard, make sure state is properly updated
      setState(() {
        _riveArtboard = artboard;
        _controller = null;
      });

      print('rive file loaded successfully!');
      checkRiveAnimation();
    }).catchError((error) {
      print("error loading rive animation: $error");
    });
  }

  @override
  void initState() {
    super.initState();

    // load the rive file when the widget is initialized
    _loadRiveFile();
  }
  
  void playSleepAnimation(String timelineName) {
    // check to see if artboard is initialized
    if (_riveArtboard == null) {
      print("error: artboard is not initialized");
      return;
    }

    print("artboard is initialized. checking controller...");

    // remove old controller if it exists
    if (_controller != null) {
      _riveArtboard!.removeController(_controller!);
      print("removed existing controller");
    }

    // add a new animation controller for the specified timeline
    _controller = rive.SimpleAnimation(timelineName);
    _riveArtboard!.addController(_controller!);
    print("playing animation: $timelineName");

    // trigger a rebuild to display updates
    setState(() {
      print("set state called for animation rebuild");
    });
  }

  // having issues with Rive but bc i have the free version of Rive, I can't reupload the file into the Rive editor
  // so this is me manually trying to check the names of the Rive files
  // UGH im going crazy
  void checkRiveAnimation() {
    if (_riveArtboard == null) {
      print("Error: Artboard not initialized");
      return;
    }

    print("Listing available animations: ");
    for (var animation in _riveArtboard!.animations) {
      print('Animation: ${animation.name}');
    }
  }



  ////////////////////////////////////////////////////////////
  // handle navigation bar items
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  static const List<Widget> widgetOption = <Widget>[
    Text(
      'Index 0: Home',
      style: TextStyle(fontSize: 25),
    ),
    const musicselect(),
     DreamJournalPage(),
    const VideoView(),
    const DailyReflectionPage(title: 'Daily Reflection'),
    const DailySleepQuizPage(title: 'Sleep Quiz'),
    const BehaviorQuizPage(title: 'Behavior Quiz'),
    const DailyReflectionAveragePage(title: 'Average Behavior Scores'),
    const SleepTimePage(title: 'Sleep Time'),
    const WakeUpPage(title: 'Wake Up Time'),
  ];

  //////////////////////////////////////////////////////////////
  
  /////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4ADFC),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: const Color(0xFF5C469C),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _riveArtboard == null ? const SizedBox() : SizedBox(
                height: 100,
                width: 200,
                child: rive.Rive(artboard: _riveArtboard!),
              ),
              ElevatedButton(
                onPressed: startSleep,
                child: Text('Start Sleep'),
              ),

              SizedBox(height: 20), // space between buttons

              ElevatedButton(
                onPressed: wakeUp,
                child: Text('Wake Up'),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: calculateHoursSlept,
                child: Text('Calculate Hours Slept'),
              ),

              SizedBox(height: 20),

              Text("Hours slept: ${hoursSlept ?? 0.0} hours"),
              if (showSleepMessage && sleepMessage != null)
                Text(sleepMessage!),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // this allows the bottomnavbar to have more than 3 items 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow_outlined),
            label: 'Video',
          ),
          /*
          const DailyReflectionPage(title: 'Daily Reflection'),
          const DailySleepQuizPage(title: 'Sleep Quiz'),
          const BehaviorQuizPage(title: 'Behavior Quiz'),
          const DailyReflectionAveragePage(title: 'Average Behavior Scores'),
          const SleepTimePage(title: 'Sleep Time'),
          const WakeUpPage(title: 'Wake Up Time'),
           */
          BottomNavigationBarItem(
            icon: Icon(Icons.abc_rounded),
            label: 'Reflection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card),
            label: 'Sleep Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_sharp),
            label: 'Behaviors Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_rounded),
            label: 'Behavior Scores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_rounded),
            label: 'Sleep Time',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled_rounded),
            label: 'Wake Up Time',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: onItemTapped,
      ),
    );
  }
}