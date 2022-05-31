import 'dart:developer';

import 'package:flutter/foundation.dart';
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
    List<dynamic> evts = GetStorage().read('events');
    evts.removeWhere((element) => element['timeStamp'] == event.timeStamp);
    GetStorage().write('events', evts);
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
