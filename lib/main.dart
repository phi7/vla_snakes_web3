import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:vla_snake_game/game/game_page.dart';
import 'dart:math';
import 'dart:async';

import 'home_page.dart';

// import 'home/home_page.dart';
// import 'login/login_page.dart';

// void main() => runApp(MyApp());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCCyz3vErKNbZZFcywITGGhLWJbjkirUu0",
        authDomain: "vla-snakes-web3.firebaseapp.com",
        projectId: "vla-snakes-web3",
        storageBucket: "vla-snakes-web3.appspot.com",
        messagingSenderId: "595455404721",
        appId: "1:595455404721:web:650d4dd002234bf3dc1090",
        measurementId: "G-ZK5K9B1PS8"
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter app',
    home: HomePage(),
  );
}



// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//     title: 'Flutter app',
//     home: StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // スプラッシュ画面などに書き換えても良い
//           return const SizedBox();
//         }
//         if (snapshot.hasData) {
//           // User が null でなない、つまりサインイン済みのホーム画面へ
//           return SnakeGame();
//         }
//         // User が null である、つまり未サインインのサインイン画面へ
//         return LoginPage();
//       },
//     ),
//   );
// }