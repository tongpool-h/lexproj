import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lexproj/states/authen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
     runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Authen(),
    );
  }
}
