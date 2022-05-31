import 'package:get/get.dart';
import 'package:smirl_timer/src/app/services/timer_service.dart';

class Services {
  static Future<void> init() async {
    Get.put<TimerService>(TimerService());
  }
}
