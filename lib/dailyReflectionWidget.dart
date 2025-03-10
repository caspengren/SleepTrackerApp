import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main () async {
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
      title: 'Daily Reflection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DailyReflectionPage(title: 'Daily Reflection'),
    );
  }
}

class DailyReflectionPage extends StatefulWidget {
  const DailyReflectionPage({super.key, required this.title});

  final String title;

  @override
  State<DailyReflectionPage> createState() => _DailyReflectionPageState();
}

class _DailyReflectionPageState extends State<DailyReflectionPage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  List<Widget> Messages = [];

  @override
  void initState() {
    super.initState();
    databaseReference.onChildAdded.listen((DatabaseEvent event) {
      final String sender = event.snapshot.children.first.value.toString();
      final String message = event.snapshot.children.last.value.toString();
      addMessage(sender, message);
    });
  }

  void addMessage(String sender, String message) {
    //print(sender + ": " + message);
    setState(() {
      final String formattedMessage = sender + ": " + message;
      Text messageWidget = Text(
        formattedMessage,
        style: TextStyle(fontSize: 25),
      );

      Messages.add(messageWidget);
    });
  }

  void sendEntry(String entry) async {
    DateTime now = DateTime.now();
    int day = now.day;
    int month = now.month;
    int year = now.year;
    String date = "$month/$day/$year";
    databaseReference.push().set({'Sender': date, 'entry': entry});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget> [
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                              children: Messages,
                            )),
                      ),
                      Container(
                          height: 120.0,
                          alignment: Alignment.center,
                          child: TextField(
                            onSubmitted: (String value) async {
                              sendEntry(value);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Daily Reflection Journal',
                              hintText: 'Write about the activities of the previous day and how they affected your sleep',
                            ),
                          )
                      )],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
