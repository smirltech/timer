import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends HiveObject {
  /// This is the table name in the Hive database.
  static const String table_name = 'events';

  @HiveField(0)
  String? description;
  @HiveField(1)
  String? date;
  @HiveField(2)
  bool? isDone = false;
  @HiveField(3)
  String? timeStamp;

  EventModel({
    this.description,
    this.date,
    this.isDone,
    this.timeStamp,
  }) {
    try {
      DateTime now = DateTime.now();
      DateTime old = DateTime.parse(date!);
      // log("old date: $old, new date: $now");
      if (old.isBefore(now)) {
        this.isDone = true;
        //  print("is done :::${this.isDone!}");
      }
    } catch (e) {
      // print(this.timeStamp! + " ::::: " + e.toString());
    }
  }

  static EventModel fromJson(Map<String, dynamic> json) {
    EventModel em = EventModel(
      description: json["description"],
      date: json["date"],
      isDone: json["isDone"],
      timeStamp: json["timeStamp"],
    );
    try {
      DateTime dn = DateTime.parse(em.date!);
      if (dn.isBefore(DateTime.now())) {
        em.isDone = true;
        //   print("is done :::${em.isDone!}");
      }
    } catch (e) {
      // print(em.timeStamp! + " ::: " + e.toString());
    }
    return em;
  }

  toJson() {
    return {
      'description': description,
      'date': date,
      'isDone': isDone,
      'timeStamp': timeStamp,
    };
  }

  static List<EventModel> fromJsonList(List<dynamic> jsonList) {
    List<EventModel> list =
        jsonList.map((e) => EventModel.fromJson(e)).toList();
    list.sort((a, b) {
      DateTime dnA = DateTime.parse(a.date!);
      DateTime dnB = DateTime.parse(b.date!);
      return dnB.compareTo(dnA);
    });
    return list;
  }
}
