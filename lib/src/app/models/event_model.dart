class EventModel {
  String? description;
  String? date;
  bool? isDone;
  String? timeStamp;

  EventModel({
    this.description,
    this.date,
    this.isDone,
    this.timeStamp,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        description: json["description"],
        date: json["date"],
        isDone: json["isDone"],
        timeStamp: json["timeStamp"],
      );

  toJson() {
    return {
      'description': description,
      'date': date,
      'isDone': isDone,
      'timeStamp': timeStamp,
    };
  }

  static List<EventModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => EventModel.fromJson(e)).toList();
}
