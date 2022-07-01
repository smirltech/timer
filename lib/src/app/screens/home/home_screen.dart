import 'dart:developer';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smirl_timer/src/app/models/event_model.dart';
import 'package:smirl_timer/src/app/screens/home/components/timer_block.dart';
import 'package:counter_card/counter_card.dart';
import 'package:smirl_timer/src/system/components/date_form_field.dart';

import '../../services/timer_service.dart';
import '../events/events_screen.dart';

class HomeScreen extends StatelessWidget {
  final _timerService = Get.find<TimerService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewEvent();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(8),
              child: SizedBox(
                height: Get.height * 0.30,
                // color: Colors.white54,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Temps restant : ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_timerService.days.value > 0)
                              TimerBlock(
                                count: _timerService.days.value,
                                suffix: '',
                              ),
                            if (_timerService.days.value > 0)
                              const SizedBox(width: 5),
                            if (_timerService.days.value > 0)
                              const Text(
                                'J',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            if (_timerService.days.value > 0)
                              const SizedBox(width: 5),
                            if (_timerService.days.value > 0 ||
                                _timerService.hours.value > 0)
                              TimerBlock(
                                count: _timerService.hours.value,
                                suffix: '',
                              ),
                            if (_timerService.days.value > 0 ||
                                _timerService.hours.value > 0)
                              const Text(
                                ':',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            // const SizedBox(width: 5),
                            if (_timerService.days.value > 0 ||
                                _timerService.hours.value > 0 ||
                                _timerService.minutes.value > 0)
                              TimerBlock(
                                count: _timerService.minutes.value,
                                suffix: '',
                              ),
                            if (_timerService.days.value > 0 ||
                                _timerService.hours.value > 0 ||
                                _timerService.minutes.value > 0)
                              const Text(
                                ':',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            // const SizedBox(width: 5),
                            TimerBlock(
                              count: _timerService.seconds.value,
                              suffix: '',
                            ),
                          ],
                        );
                      }),
                      if (_timerService.currentEvent.value != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(() {
                            return Text(
                              "À : ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(_timerService.currentEvent.value!.date!)).toString()}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            );
                          }),
                        ),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              _timerService.currentEvent.value?.description ??
                                  'Smirl Timer',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16)),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Evénements",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    child: const Text(
                      "Voir tous >>",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Get.to(() => EventsScreen());
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Obx(() {
                  if (_timerService.events.isEmpty) {
                    return const Center(
                      child: Text('No events listed !'),
                    );
                  }
                  return ListView(
                      children: _timerService.events.value
                          .where((p0) => p0.isDone == false)
                          .map(
                            (evt) => CounterCard(
                                data: {
                                  'description': evt.description,
                                  'date': evt.date,
                                  'isDone': evt.isDone,
                                },
                                onSelected: () {
                                  log('Selected event : ${evt.date}');
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
            ),
          ],
        ),
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
            const SizedBox(height: 5),
            const Text("Ajouter nouvel événement",
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                event['description'] = value;
              },
            ),
            const SizedBox(height: 5),
            DateFormField(
              label: 'Date',
              type: DateFormFieldType.datetime,
              dateDisplayFormat: 'dd/MM/yyyy HH:mm:ss',
              onDateChanged: (date) {
                event['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
              },
            ),
            const SizedBox(height: 5),
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
            const SizedBox(height: 5),
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
