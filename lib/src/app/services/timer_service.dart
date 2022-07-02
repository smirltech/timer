import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:smirl_timer/src/app/models/event_model.dart';
import '../../../main.dart';
import '../../system/helpers.dart';
import '../api/boxes.dart';

class TimerService extends GetxService {
  late Box<EventModel> box;
  var seconds = 0.obs;
  var minutes = 0.obs;
  var hours = 0.obs;
  var days = 0.obs;
  var currentEvent = Rxn<EventModel>();

  var events = <EventModel>[].obs;

  void start() {
    Stream.periodic(const Duration(seconds: 1), (i) {
      if (currentEvent.value != null) {
        DateTime dt = DateTime.parse(currentEvent.value!.date!);
        DateTime now = DateTime.now();
        var diff = dt.difference(now).inSeconds;
        Map<String, int> ds = intToTimeLeft(diff);
        seconds.value = ds['s']!;
        minutes.value = ds['m']!;
        hours.value = ds['h']!;
        days.value = ds['d']!;
      }
    }).listen((_) {});
  }

  addEvent(EventModel event) async {
    box.put(event.id, event);
  }

  Future<EventModel?> getEvent(String event_id) async {
    return box.get(event_id);
  }

  editEvent(EventModel event) async {
    event.save();
  }

  deleteEvent(EventModel event) async {
    Get.defaultDialog(
      title: "Supprimer l'événement ?",
      content: const Text("Êtes-vous sûr de vouloir supprimer cet événement ?"),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () {
            event.delete();
            Get.back();
          },
          child: const Text('Supprimer'),
        ),
      ],
    );
  }

  deleteAllEvents() async {
    Get.defaultDialog(
      title: "Supprimer tous lesévénements ?",
      content: const Text(
          "Êtes-vous sûr de vouloir supprimer tous les événements ?"),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () {
            box.clear();
            Get.back();
          },
          child: const Text('Supprimer'),
        ),
      ],
    );
  }

  selectEvent(EventModel event) {
    currentEvent.value = event;
    //log("Selected event: ${event.id}");
  }

  @override
  onInit() async {
    await Hive.openBox<EventModel>(EventModel.table_name);
    box = Boxes.getEvents();
    super.onInit();

    readAllEvents();
    start();
  }

  @override
  onClose() async {
    await Hive.close();
    super.onClose();
  }

  readAllEvents() async {
    //  isLoading.value = true;
    final _box = box.listenable();
    events.value = _box.value.values.toList();
    events.value.sort((a, b) {
      DateTime dnA = DateTime.parse(a.date!);
      DateTime dnB = DateTime.parse(b.date!);
      return dnA.compareTo(dnB);
    });
    _box.addListener(() {
      events.value = _box.value.values.toList();
      events.value.sort((a, b) {
        DateTime dnA = DateTime.parse(a.date!);
        DateTime dnB = DateTime.parse(b.date!);
        return dnA.compareTo(dnB);
      });
    });
    //  if (events.value.isNotEmpty) currentEvent.value = events.value.first;
    // isLoading.value = false;
  }
}
