// page that contains the dream journal

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DreamJournalPage extends StatefulWidget {
  const DreamJournalPage({super.key});

  @override
  DreamJournalPageState createState() => DreamJournalPageState();
}

class DreamJournalPageState extends State<DreamJournalPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dream Journal'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarFormat: _calendarFormat,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_selectedDay != null) {
                _showDreamInputDialog(context);
              }
            },
            child: const Text('Add Dream Entry'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firebaseFirestore
                  .collection('dreams')
                  .doc(_selectedDay.toString()) // selected day in table calendar is used for doc ID
                  .collection('entries')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No dream entries for this day.'));
                }

                final dreamEntries = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: dreamEntries.length,
                  itemBuilder: (context, index) {
                    final dreamEntry = dreamEntries[index].get('entry');
                    return ListTile(
                      title: Text(dreamEntry),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditDreamDialog(context, dreamEntry, index, dreamEntries[index].id);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteDreamEntry(dreamEntries[index].id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // function to add dream entry
  void _showDreamInputDialog(BuildContext context) {
    TextEditingController dreamEntryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Dream Entry'),
          content: TextField(
            controller: dreamEntryController,
            decoration: const InputDecoration(hintText: 'Describe your dream'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_selectedDay != null) {
                  final dreamEntry = dreamEntryController.text;

                  // save entry to cloud firestore
                  await _firebaseFirestore
                      .collection('dreams')
                      .doc(_selectedDay.toString())
                      .collection('entries')
                      .add({
                    'entry': dreamEntry,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // function to edit dream entry
  void _showEditDreamDialog(BuildContext context, String entry, int index, String docId) {
    TextEditingController dreamEntryController = TextEditingController(text: entry);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Dream Entry'),
          content: TextField(
            controller: dreamEntryController,
            decoration: const InputDecoration(hintText: 'Edit dream entry'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_selectedDay != null) {
                  final updatedEntry = dreamEntryController.text;

                  // update entry in cloud firestore
                  await _firebaseFirestore
                      .collection('dreams')
                      .doc(_selectedDay.toString())
                      .collection('entries')
                      .doc(docId)
                      .update({
                    'entry': updatedEntry,
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // function to delete dream entry
  void _deleteDreamEntry(String docId) async {
    if (_selectedDay != null) {
      await _firebaseFirestore
          .collection('dreams')
          .doc(_selectedDay.toString())
          .collection('entries')
          .doc(docId)
          .delete();
    }
  }
}