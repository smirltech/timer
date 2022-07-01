import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:smirl_timer/src/app/models/event_model.dart';
import 'package:smirl_timer/src/app/screens/home/home_screen.dart';
import 'package:smirl_timer/src/app/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EventModelAdapter());
  await GetStorage.init();
  await Services.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smirl Timer',
      theme: ThemeData(
        primarySwatch: Colors.green,
        backgroundColor: Colors.white60,
        fontFamily: GoogleFonts.monda().fontFamily,
      ),
      home: AnimatedSplashScreen(
        duration: 1000,
        splash: Image.asset(
          "assets/images/icons/icon.png",
        ),
        nextScreen: HomeScreen(),
        backgroundColor: Colors.green.shade400,
        splashTransition: SplashTransition.fadeTransition,
        //pageTransitionType: PageTransitionType.scale,
      ),
    );
  }
}
