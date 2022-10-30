import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'snakegame_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // const HomePage({Key? key}) : super(key: key);

  @override
  void initState() {
    super.initState();
    print("initState");
    _onSignInWithAnonymousUser();
  }


  Future<void> _onSignInWithAnonymousUser() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try{

      await firebaseAuth.signInAnonymously();

    }catch(e) {
      print(e);
      // await showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: Text('エラー'),
      //         content: Text(e.toString()),
      //       );
      //     }
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'べりろんスネークゲーム',
          style: TextStyle(
            shadows: [
              Shadow(
                blurRadius: 4.0,
              ),
            ],
            fontSize: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('images/vla_snake_home.png'),
        ),
        ElevatedButton(onPressed: ()async{
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => SnakeGamePage(),
              )
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SnakeGamePage(),
            ),
          );


        }, child: const Text("はじめる"))
      ],
    )));
  }
}

