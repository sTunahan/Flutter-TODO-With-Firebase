import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notebooktwo/signupsceen.dart';
import 'package:notebooktwo/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance
              .authStateChanges(), // stream firebase e bakarak akış saglar
          builder: (context, userData) {
            // builder firebase den gelen veriye göre bilgiye göre inşa etmemizi saglar.
            if (userData.hasData) {
              // veri var ise
              return ToDoSceen();
            } else {
              return SignUpSceen();
            }
          }),
    );
  }
}
