import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:smirl_timer/src/app/models/event_model.dart';
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

  addEvent(EventModel event) {
    box.add(event);
  }

  editEvent(EventModel event) {
    event.save();
  }

  deleteEvent(EventModel event) {
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

  selectEvent(EventModel event) {
    currentEvent.value = event;
  }

  onInit() async {
    await Hive.openBox<EventModel>(EventModel.table_name);
    box = Boxes.getEvents();
    super.onInit();

    readAllEvents();
    start();
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
