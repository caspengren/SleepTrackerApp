// navigation page that has buttons to navigate to the dream journal or sleep quiz

import 'package:flutter/material.dart';
import 'dreamJournal.dart';
import 'sleepQuizWidget.dart';

class JournalNavigationPage extends StatelessWidget {
  const JournalNavigationPage({super.key});

  final Color color1 = const Color(0xFFD4ADFC);
  final Color color2 = const Color(0xFF5C469C);
  final Color color3 = const Color(0xFF0C134F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Navigation'),
        backgroundColor: color1,
      ),
      body: Container(
        color: color3,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: color2,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DreamJournalPage(),
                    ),
                  );
                },
                child: const Text('Go to Dream Journal'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: color2,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DailySleepQuizPage(title: 'Sleep Quiz',),
                    ),
                  );
                },
                child: const Text('Go to Sleep Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}