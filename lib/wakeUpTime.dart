import 'package:flutter/material.dart';
import 'package:group_number_h/SleepRecommendations.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';



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
      home: const WakeUpPage(title: 'Sleep Recommendation'),
    );
  }
}

class WakeUpPage extends StatefulWidget {
  const WakeUpPage({super.key, required this.title});

  final String title;

  @override
  State<WakeUpPage> createState() => _WakeUpPageState();
}

class _WakeUpPageState extends State<WakeUpPage> {
  int _sleepRec = 0;
  int _hours = 0;

  void _SleepCalculator() {
    setState(() {
      SleepRecommendations sleepCalq = SleepRecommendations();
      _sleepRec = sleepCalq.whenWake(DateTime(2024, _hours, _hours, _hours));

    });
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://www.cdc.gov/sleep/index.html');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
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
                'you should wake up at this time'
            ),
            Text(
              '$_sleepRec:00',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            TextField(
              onSubmitted:(String value) async{
                _hours = value as int;
              },
              decoration: InputDecoration(labelText: "When do you want to sleep?: 24 Hour Clock"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              // Only numbers can be entered
            ),

            SizedBox(height: 20), //creating blank space
            GestureDetector(
              onTap: _launchURL,
              child: Text(
                '[Click Here To Find More Info About CDC Recommended Sleep]',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              )
            )
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
