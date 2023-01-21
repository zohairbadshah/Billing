import 'drawing_page.dart';
import 'history.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'home.dart';
import 'package:pinput/pinput.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const authenticate());
}

class authenticate extends StatefulWidget {
  const authenticate({Key? key}) : super(key: key);

  @override
  State<authenticate> createState() => _authenticateState();
}

class _authenticateState extends State<authenticate> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/home': (context) => home(),
        '/history': (context) => history()
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DrawingPage(),
      ),
    );
  }
}
