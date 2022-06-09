import 'dart:developer';

import 'package:counter_card/counter_card.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/event_model.dart';
import '../../services/timer_service.dart';

class EventsScreen extends StatelessWidget {
  EventsScreen({Key? key}) : super(key: key);
  final _timerService = Get.find<TimerService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Evénements'),
        actions: [
          TextButton(
            onPressed: null,
            child: Obx(() {
              return Text(
                '${_timerService.events.length}',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              );
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewEvent();
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Obx(() {
          if (_timerService.events.isEmpty) {
            return const Center(
              child: Text('No events listed !'),
            );
          }
          return ListView(
              children: _timerService.events.value
                  .map(
                    (evt) => CounterCard(
                        data: {
                          'description': evt.description,
                          'date': evt.date,
                          'isDone': evt.isDone,
                        },
                        onSelected: () {
                          log('Selected event : ${evt.description}');
                          _timerService.selectEvent(evt);
                        },
                        onEdited: () {
                          editOldEvent(evt);
                        },
                        onDeleted: () {
                          _timerService.deleteEvent(evt);
                        }),
                  )
                  .toList());
        }),
      ),
    );
  }

  addNewEvent() {
    Map<String, dynamic> event = {
      'description': '',
      'date': '',
      'isDone': false,
    };
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text("Ajouter nouvel événement",
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                event['description'] = value;
              },
            ),
            DateTimeFormField(
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black45),
                errorStyle: TextStyle(color: Colors.redAccent),
                //border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.event_note),
                labelText: 'Date',
              ),
              initialValue: DateTime.now(),
              // mode: DateTimeFieldPickerMode.date,
              autovalidateMode: AutovalidateMode.always,
              onDateSelected: (DateTime value) {
                // print(value);
                event['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Enregistrer'),
              onPressed: () {
                _timerService.addEvent(EventModel(
                    description: event['description'],
                    date: event['date'],
                    isDone: event['isDone'],
                    timeStamp:
                        DateTime.now().millisecondsSinceEpoch.toString()));
                Get.back();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  editOldEvent(EventModel eventModel) {
    Map<String, dynamic> event = {
      'description': eventModel.description,
      'date': eventModel.date,
      'isDone': eventModel.isDone,
      'timeStamp': eventModel.timeStamp
    };
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text("Modifier événement", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: event['description'],
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                event['description'] = value;
              },
            ),
            DateTimeFormField(
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black45),
                errorStyle: TextStyle(color: Colors.redAccent),
                //border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.event_note),
                labelText: 'Date',
              ),
              initialValue: DateTime.parse(event['date']),
              //  mode: DateTimeFieldPickerMode.date,
              autovalidateMode: AutovalidateMode.always,
              onDateSelected: (DateTime value) {
                // print(value);
                event['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Confirmer'),
              onPressed: () {
                _timerService.editEvent(EventModel(
                    description: event['description'],
                    date: event['date'],
                    isDone: event['isDone'],
                    timeStamp: event['timeStamp']));
                Get.back();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
