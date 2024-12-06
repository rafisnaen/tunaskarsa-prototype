import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:tunaskarsa/pages/homePage.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<NeatCleanCalendarEvent> _eventList = [
    NeatCleanCalendarEvent(
      'Math Exam',
      description: 'Chapter 5: Calculus',
      startTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0),
      endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0),
      color: Colors.blue,
    ),
    NeatCleanCalendarEvent(
      'History Presentation',
      description: 'World War II Overview',
      startTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 14, 0),
      endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 15, 0),
      color: Colors.red,
    ),
    NeatCleanCalendarEvent(
      'Team Meeting',
      description: 'Discuss project progress',
      startTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 9, 0),
      endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 10, 30),
      color: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: const Color(0xFF8EB486),
        automaticallyImplyLeading: false,
        // leading: IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));}, icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Calendar(
          startOnMonday: true,
          weekDays: const ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
          eventsList: _eventList,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: const Color(0xFF8EB486),
          selectedTodayColor: const Color(0xFFFF7043),
          todayColor: Colors.blue,
          eventColor: Colors.grey,
          locale: 'en_US',
          todayButtonText: 'Today',
          allDayEventText: 'All Day',
          multiDayEndText: 'End',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd MMMM yyyy',
          datePickerType: DatePickerType.date,
          dayOfWeekStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEvent(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF8EB486),
      ),
    );
  }

  void _addEvent(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final descController = TextEditingController();
        final dateController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Event Date (yyyy-MM-dd HH:mm)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final description = descController.text;
                final dateString = dateController.text;

                if (title.isNotEmpty && description.isNotEmpty && dateString.isNotEmpty) {
                  final date = DateTime.tryParse(dateString);
                  if (date != null) {
                    setState(() {
                      _eventList.add(
                        NeatCleanCalendarEvent(
                          title,
                          description: description,
                          startTime: date,
                          endTime: date.add(const Duration(hours: 1)),
                          color: Colors.purple,
                        ),
                      );
                    });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
