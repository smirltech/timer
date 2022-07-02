import 'dart:developer';

import 'package:get_time_ago/get_time_ago.dart';
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
  @HiveField(4)
  String? id;

  EventModel({
    this.description,
    this.date,
    this.isDone,
    this.timeStamp,
    this.id,
  }) {
    try {
      DateTime now = DateTime.now();
      DateTime old = DateTime.parse(date!);
      // log("old date: $old, new date: $now");
      if (old.isBefore(now)) {
        this.isDone = true;
      }
    } catch (e) {}
  }

  getTimeLeft() {
    DateTime old = DateTime.parse(date!);
    return GetTimeAgo.parse(old);
  }
}
