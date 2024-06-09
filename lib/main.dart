import 'package:flutter/material.dart';
import 'package:tris/Home.dart';

import 'games/Tris.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  //Obbligatori per utilizzo di firebase

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  //Run normale dell'app
  runApp(const MyApp());
}

// Il widget principale dell'app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tris',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        //'/': (context) => const Home(),
        '/tris': (context) => const Tris(),
      },
      home: Home(),
    );
  }
}
