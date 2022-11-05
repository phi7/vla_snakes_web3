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
        apiKey: "AIzaSyBX7NAf_8R84t3u-E0wnCm_xSVvMvE20oo",
        authDomain: "tokyo-web3.firebaseapp.com",
        projectId: "tokyo-web3",
        storageBucket: "tokyo-web3.appspot.com",
        messagingSenderId: "206673147333",
        appId: "1:206673147333:web:f85647d9493e32929bc7ac",
        measurementId: "G-1EGQZJGW9X"
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