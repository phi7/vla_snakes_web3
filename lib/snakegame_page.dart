import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SnakeGamePage extends StatefulWidget {
  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  final int squaresPerRow = 10;
  final int squaresPerCol = 20;
  final fontStyle = const TextStyle(color: Colors.black, fontSize: 20);
  final randomGen = Random();
  var blockImg;
  int bestScore = 0;
  int totalScore = 0;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? currentUser;
  late CollectionReference users;
  late DocumentSnapshot userDoc;


  var snake = [
    [0, 1],
    [0, 0]
  ];
  var food = [0, 2];
  var direction = 'up';
  var isPlaying = false;
  int snakeBodyIndex = 0;
  var preSnakeBodyPos = [];

  @override
  void initState() {
    super.initState();
    Future(() async {
      currentUser = FirebaseAuth.instance.currentUser!;
      print(currentUser!.uid);
      users = FirebaseFirestore.instance.collection('users');
      userDoc = await users.doc(currentUser!.uid).get();
      if(userDoc.exists){
        setState((){
          bestScore = userDoc.get("bestScore");
          totalScore =  userDoc.get("totalScore");
        });
      }else{
        setState((){
          bestScore = 0;
          totalScore = 0;
        });
        users.doc(currentUser!.uid)
            .set({
          'bestScore': bestScore,
          'totalScore': totalScore,
        })
            .then((value) => print("bestScore:$bestScore, totalScore:$totalScore"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });

  }

  void startGame() {
    const duration = Duration(milliseconds: 300);

    snake = [ // Snake head
      [(squaresPerRow / 2).floor(), (squaresPerCol / 2).floor()]
    ];

    snake.add([snake.first[0], snake.first[1]+1]); // Snake body

    createFood();

    isPlaying = true;
    Timer.periodic(duration, (Timer timer) {
      moveSnake();
      if (checkGameOver()) {
        timer.cancel();
        endGame();
      }
    });
  }

  void moveSnake() {
    setState(() {
      switch(direction) {
        case 'up':
          snake.insert(0, [snake.first[0], snake.first[1] - 1]);
          break;

        case 'down':
          snake.insert(0, [snake.first[0], snake.first[1] + 1]);
          break;

        case 'left':
          snake.insert(0, [snake.first[0] - 1, snake.first[1]]);
          break;

        case 'right':
          snake.insert(0, [snake.first[0] + 1, snake.first[1]]);
          break;
      }

      if (snake.first[0] != food[0] || snake.first[1] != food[1]) {
        snake.removeLast();
      } else {
        createFood();
      }
    });
  }

  void createFood() {
    food = [
      randomGen.nextInt(squaresPerRow),
      randomGen.nextInt(squaresPerCol)
    ];
  }

  bool checkGameOver() {
    if (!isPlaying
        || snake.first[1] < 0
        || snake.first[1] >= squaresPerCol
        || snake.first[0] < 0
        || snake.first[0] > squaresPerRow
    ) {
      return true;
    }

    for(var i=1; i < snake.length; ++i) {
      if (snake[i][0] == snake.first[0] && snake[i][1] == snake.first[1]) {
        return true;
      }
    }

    return false;
  }

  void endGame() {
    isPlaying = false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text(
              'Score: ${snake.length - 2}',
              style: const TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
    registerRecord();
  }

  void registerRecord()async{
    // final currentUser = FirebaseAuth.instance.currentUser;
    // print(currentUser!.uid);
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // final userDoc = await users.doc(currentUser!.uid).get();
    // if(userDoc.exists){
    //   bestScore = userDoc.get("bestScore");
    //   totalScore =  userDoc.get("totalScore");
    // }
    bestScore = snake.length - 2 > bestScore ? snake.length - 2 : bestScore;
    totalScore = totalScore +  snake.length - 2;
    users.doc(currentUser!.uid)
        .set({
      'bestScore': bestScore,
      'totalScore': totalScore,
    })
        .then((value) => print("bestScore:$bestScore, totalScore:$totalScore"))
        .catchError((error) => print("Failed to add user: $error"));

  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: <Widget>[
          SizedBox(height: size.height/ 12,),
          currentUser != null ? Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("UID："),
              CopyableText(currentUser!.uid.toString()),
            ],
          )) : const CircularProgressIndicator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform.rotate(
                angle: 180 * pi / 180,
                  child: IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, icon: const Icon(Icons.exit_to_app,size: 40,))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Best: $bestScore',
                    style: fontStyle,
                  ),
                  const SizedBox(width: 8,),
                  Text('Total: $totalScore',
                    style: fontStyle,)
                ],
              ),
              const SizedBox(width: 40,),
            ],
          ),
          Expanded(
            //まさかのドラッグ形式．十字カーソルに書き直すか？？
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: AspectRatio(
                aspectRatio: squaresPerRow / (squaresPerCol + 5),
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: squaresPerRow,
                    ),
                    itemCount: squaresPerRow * squaresPerCol,
                    itemBuilder: (BuildContext context, int index) {
                      // var color;
                      var x = index % squaresPerRow;
                      var y = (index / squaresPerRow).floor();

                      //snakeを構成するパーツの座標かどうかチェックしている
                      bool isSnakeBody = false;
                      //そのパーツが何番目か
                      snakeBodyIndex = 0;
                      for (var pos in snake) {
                        if (pos[0] == x && pos[1] == y) {
                          isSnakeBody = true;
                          break;
                        }
                        snakeBodyIndex += 1;
                      }

                      //foreach文だとbreakできないので上の汚い書き方をする
                      // snake.asMap().forEach((int i, List<int> pos) {
                      //     if (pos[0] == x && pos[1] == y) {
                      //       snakeBodyIndex = i;
                      //       isSnakeBody = true;
                      //     }


                      //snakeの体がtrueであっても先に，頭が判定されるので関係なし
                      if (snake.first[0] == x && snake.first[1] == y) {
                        // color = Colors.green;
                        if(direction=='up'){
                          blockImg = 'images/vla_tiger_head_up.png';
                        }else if(direction=='right'){
                          blockImg = 'images/vla_tiger_head_right.png';
                        }else if(direction=='left'){
                          blockImg = 'images/vla_tiger_head_left.png';
                        }else if(direction=='down'){
                          blockImg = 'images/vla_tiger_head_down.png';
                        }
                      } else if (isSnakeBody) {
                        // color = Colors.green[200];
                        //二次元配列にindexOfが使えないので上の方のisSnakeBodyのfor文で処理する
                        // snakeBodyIndex = snake.indexOf([x,y]);
                        preSnakeBodyPos = snake[snakeBodyIndex - 1];
                        //着目しているsnakebodyの座標の前のブロックの座標と比較して体の向きを決定する
                        if(preSnakeBodyPos[0]==x && (preSnakeBodyPos[1]-y)<0){
                          blockImg = 'images/vla_tiger_body_up.png';
                        }else if(preSnakeBodyPos[1]==y && (preSnakeBodyPos[0]-x)>0){
                          blockImg = 'images/vla_tiger_body_right.png';
                        }else if(preSnakeBodyPos[1]==y && (preSnakeBodyPos[0]-x)<0){
                          blockImg = 'images/vla_tiger_body_left.png';
                        }else if(preSnakeBodyPos[0]==x && (preSnakeBodyPos[1]-y)>0){
                          blockImg = 'images/vla_tiger_body_down.png';
                        }
                      } else if (food[0] == x && food[1] == y) {
                        // color = Colors.red;
                        blockImg = 'images/vla_potato.jpeg';
                      } else {
                        // color = Colors.grey[800];
                        blockImg = 'images/gray_square.jpeg';
                      }

                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(blockImg),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // margin: EdgeInsets.all(1),
                        // child: Image.asset(blockImg),
                        // decoration: BoxDecoration(
                        //   color: color,
                        //   // shape: BoxShape.,
                        // ),
                      );
                    }),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: isPlaying ?  MaterialStateProperty.all<Color>(Colors.red) :MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      // color: isPlaying ? Colors.red : Colors.blue,
                      child: Text(
                        isPlaying ? 'End' : 'Start',
                        style: fontStyle,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          isPlaying = false;
                        } else {
                          startGame();
                        }
                      }),
                  const SizedBox(width: 16,),
                  Text(
                    'NowScore: ${snake.length - 2}',
                    style: fontStyle,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class CopyableText extends Text {
  const CopyableText(
      String data, {
        Key? key,
        TextStyle? style,
      }) : super(data, key: key, style: style);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: Colors.blue,
      onTap: () {
        // print("ボタン");
        Clipboard.setData(ClipboardData(text: data));},
      child: super.build(context),
    );
  }
}