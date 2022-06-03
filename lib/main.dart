import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smirl_timer/src/app/screens/home/home_screen.dart';
import 'package:smirl_timer/src/app/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        fontFamily: GoogleFonts.monda().fontFamily,
      ),
      home: HomeScreen(),
    );
  }
}
