import 'package:hive/hive.dart';
import 'package:smirl_timer/src/app/models/event_model.dart';

class Boxes {
  static Box<EventModel> getEvents() =>
      Hive.box<EventModel>(EventModel.table_name);
}
