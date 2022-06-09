import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smirl_timer/src/app/models/event_model.dart';
import '../../system/helpers.dart';

class TimerService extends GetxService {
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
    List<dynamic> evts = GetStorage().read('events');
    evts.add(event.toJson());
    GetStorage().write('events', evts);
    // events.value.add(event);
    //events.refresh();
  }

  editEvent(EventModel event) {
    List<dynamic> evts = GetStorage().read('events');
    evts.forEach((element) {
      if (element['timeStamp'] == event.timeStamp) {
        element['description'] = event.description;
        element['date'] = event.date;
        element['isDone'] = event.isDone;
      }
    });
    GetStorage().write('events', evts);
    // events.value.add(event);
    //events.refresh();
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
            List<dynamic> evts = GetStorage().read('events');
            int idx = evts.indexWhere((element) {
              return element['timeStamp'] == event.timeStamp;
            });
            evts.removeWhere((element) {
              return element['timeStamp'] == event.timeStamp;
            });
            if (evts.isEmpty) {
              currentEvent.value = null;
            } else {
              currentEvent.value = EventModel.fromJson(evts[0]);
            }

            /*else if (events.value.length - 1 < idx) {
              currentEvent.value =
                  EventModel.fromJson(evts[events.value.length - 1]);
            }*/
            /*else {
              if (idx == 0) {
                currentEvent.value = EventModel.fromJson(evts[0]);
              } else {
                currentEvent.value = EventModel.fromJson(evts[idx - 1]);
              }
            }*/
            GetStorage().write('events', evts);
            Get.back();
          },
          child: const Text('Supprimer'),
        ),
      ],
    );
    /*  List<dynamic> evts = GetStorage().read('events');
    evts.removeWhere((element) => element['timeStamp'] == event.timeStamp);
    GetStorage().write('events', evts);*/
  }

  selectEvent(EventModel event) {
    currentEvent.value = event;
    // debugPrint('Selected event: ${event.toJson()}');
  }

  onInit() {
    if (GetStorage().read('events') == null) {
      GetStorage().write('events', []);
    }
    events.value = EventModel.fromJsonList(GetStorage().read('events'));
    if (events.value.isNotEmpty) currentEvent.value = events.value.first;
    super.onInit();
    GetStorage().listenKey('events', (evts) {
      events.value = EventModel.fromJsonList(evts);
    });
    start();
  }
}
