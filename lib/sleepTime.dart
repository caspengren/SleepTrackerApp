import 'package:flutter/material.dart';
import 'package:group_number_h/SleepRecommendations.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SleepTimePage(title: 'Sleep Recommendation'),
    );
  }
}


class SleepTimePage extends StatefulWidget {
  const SleepTimePage({super.key, required this.title});

  final String title;


  @override
  State<SleepTimePage> createState() => _SleepTimePageState();
}

class _SleepTimePageState extends State<SleepTimePage> {
  int _hours = 0;
  int _sleepRec = 0;

  void _SleepCalculator() {
    setState(() {
      SleepRecommendations sleepCalq = SleepRecommendations();
      _sleepRec = sleepCalq.whenSleep(DateTime(2024, _sleepRec, _sleepRec, _sleepRec));
      //Need to unhardcode this
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),



      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                'you should go to sleep at this time'
            ),
            Text(
              '$_sleepRec:00',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            TextField(
              onSubmitted:(String value) async{
                _hours = value as int;
              },
              decoration: InputDecoration(labelText: "When do you want to wake up?: 24 Hour Clock"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              // Only numbers can be entered
            ),
          ],


        ),
      ),




      floatingActionButton: FloatingActionButton(
        onPressed: _SleepCalculator,
        tooltip: 'Calculate Sleep',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
