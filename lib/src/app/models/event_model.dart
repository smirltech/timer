import 'package:intl/intl.dart';

class EventModel {
  String? description;
  String? date;
  bool? isDone = false;
  String? timeStamp;

  EventModel({
    this.description,
    this.date,
    this.isDone,
    this.timeStamp,
  }) {
    try {
      DateTime dn = DateTime.parse(this.date!);
      if (dn.isBefore(DateTime.now())) {
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
