import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:women_safety_app/db/share_pref.dart';

import 'package:women_safety_app/guardian/guardian_home_screen.dart';
import 'package:women_safety_app/utils/constants.dart';

import 'woman/bottom_page.dart';
import 'login_screen.dart';


final navigatorkey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPrefference.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WOMENS SAFETY',
      // scaffoldMessengerKey: navigatorkey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.firaSansTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: MySharedPrefference.getUserType(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == ""||snapshot.data == null) {
            return LoginScreen();
          }
          if (snapshot.data == "woman") {
            return BottomPage();
          }
          if (snapshot.data == "guardian") {
            return GuardianHomeScreen();
          }

          return progressIndicator(context);
        },
      ),
    );
  }
}

// class CheckAuth extends StatelessWidget {
//   // const CheckAuth({Key? key}) : super(key: key);

//   checkData() {
//     if (MySharedPrefference.getUserType() == 'guardian') {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
