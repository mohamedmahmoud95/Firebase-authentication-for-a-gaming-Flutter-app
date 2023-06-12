import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/cloud_firestore_database_services.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../firebase_services/firebase_auth_services.dart';
import '../models/car.dart';
import '../models/gift.dart';
import '../models/user.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String? _currentName;
  int _currentTop = 300;
  int _currentLeft = 200;
  int _currentScore = 0;
  int _currentPlayerNo = 0;
  bool _currentConnected = true;

  bool score_changed = false;

  bool gameStarted = false;
  final AuthServices _authServices = AuthServices();

   Widget updateCarsList (List<Car> cars)
   {
     for (Car car in cars)
     {
       if (car.connected == false)
       {
         cars.remove(car);
       }
     }

     return const SizedBox(height: 0, width: 0,);
   }

  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);
    final cars = Provider.of<List<Car>>(context) ?? [];
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(

          floatingActionButton:  TextButton(
              onPressed: () {
                setState(() {
                  _currentConnected = false;
                  score_changed = true;
                });
                _authServices.signOut();
              },
         child:  Row(
           mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Leave game"
              ,style: TextStyle(
                  color: Colors.red[900],
                  fontSize: 15,
                ),),
              const SizedBox(width: 5,),

              Icon(Icons.logout,color: Colors.red[900],size: 15,)
            ],
          ),)
          ,

     body: StreamBuilder<UserData>(
              stream: DatabaseServices(uid: user.userID).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData? userData = snapshot.data;


                  tempUserData = userData!;
                  if (score_changed == true) {
                    DatabaseServices(uid: user.userID).updateUserData(
                      _currentName ?? snapshot.data!.name,
                      _currentTop ?? snapshot.data!.top,
                      _currentLeft ?? snapshot.data!.left,
                      _currentScore ?? snapshot.data!.score,
                      _currentPlayerNo ?? snapshot.data!.playerNo,
                      _currentConnected??snapshot.data!.connected,
                    );
                      score_changed = false;
                  }


                  return StreamProvider<List<Car>>.value(
                    value: DatabaseServices().cars,
                    initialData: [],

                    // Replace null with an empty list
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextFormField(
                            initialValue: userData.name,
                            decoration: textInputDecoration,
                            //     validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                            onChanged: (val) =>
                                setState(() => _currentName = val),
                          ),
                          SizedBox(
                            height: height - height / 2,
                            width: width - 50,
                            child: Stack(
                              children: [


                                ...gifts.map(
                                  (gift) => Positioned(
                                    left: gift.left.toDouble(),
                                    top: gift.top.toDouble(),
                                    child: Container(
                                      width: gift.size.toDouble(),
                                      height: gift.size.toDouble(),
                                      child: gift.isThreat
                                          ? Image.asset('assets/threat.png')
                                          : Image.asset('assets/health.png'),
                                    ),
                                  ),
                                ),




                                updateCarsList(cars),

                                ...cars.map((car) =>
                                   car.connected == false? const UselessWidget():
                                    Positioned(
                                    left: car.left.toDouble(),
                                    top: car.top.toDouble(),
                                    child: GestureDetector(
                                      onPanUpdate: (newPosition) {
                                        setState(() {
                                          gameStarted = true;

                                          _currentLeft = max(
                                                  0,
                                                  (_currentLeft ?? 0) +
                                                      (newPosition.delta.dx))
                                              .round();
                                          if (_currentLeft > (width - 100)) {
                                            _currentLeft = (width - 100).toInt();
                                          }
                                          _currentTop = max(
                                                  0,
                                                  (_currentTop ?? 0) +
                                                      newPosition.delta.dy)
                                              .round();
                                          if (_currentTop >
                                              (height - height / 2.5)) {
                                            _currentTop =
                                                (height - height / 2.5).toInt();
                                          }
                                        });

                                        DatabaseServices(uid: user.userID)
                                            .updateUserData(
                                          _currentName ?? snapshot.data!.name,
                                          _currentTop ?? snapshot.data!.top,
                                          _currentLeft ?? snapshot.data!.left,
                                          _currentScore ?? snapshot.data!.score,
                                          _currentPlayerNo ??
                                              snapshot.data!.playerNo,
                                        _currentConnected??snapshot.data!.connected,
                                        );
                                      },
                                      child: Container(
                                        height: 75,
                                        width: 75,
                                        child: Image.asset(
                                            'assets/car_${car.playerNo}.png'),
                                      ),
                                    )
                                    ),

                                ),
                              ],
                            ),
                          ),

                          //
                          // Center(
                          //   child: Text(gameStarted? '': 'Drag to start', style: const TextStyle(
                          //     color: Colors.blue,
                          //     fontSize: 30,
                          //     decoration: TextDecoration.none,
                          //
                          //   ),),
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {

                                      _currentLeft =
                                          max(0, (_currentLeft ?? 0) - 40);

                                    });
                                    DatabaseServices(uid: user.userID)
                                        .updateUserData(
                                      _currentName ?? snapshot.data!.name,
                                      _currentTop ?? snapshot.data!.top,
                                      _currentLeft ?? snapshot.data!.left,
                                      _currentScore ?? snapshot.data!.score,
                                      _currentPlayerNo ??
                                          snapshot.data!.playerNo,
                                      _currentConnected??snapshot.data!.connected,

                                    );
                                  },
                                  child: const Icon(Icons.arrow_back)),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _currentLeft =
                                          max(0, (_currentLeft ?? 0) + 40);
                                      if (_currentLeft > (width - 100)) {
                                        _currentLeft = (width - 100).toInt();
                                      }

                                    });

                                    DatabaseServices(uid: user.userID)
                                        .updateUserData(
                                      _currentName ?? snapshot.data!.name,
                                      _currentTop ?? snapshot.data!.top,
                                      _currentLeft ?? snapshot.data!.left,
                                      _currentScore ?? snapshot.data!.score,
                                      _currentPlayerNo ??
                                          snapshot.data!.playerNo,
                                      _currentConnected??snapshot.data!.connected,

                                    );
                                  },
                                  child: const Icon(Icons.arrow_forward)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    // if(_formKey.currentState!.validate()){
                                    await DatabaseServices(uid: user.userID)
                                        .updateUserData(
                                      _currentName ?? snapshot.data!.name,
                                      _currentTop ?? snapshot.data!.top,
                                      _currentLeft ?? snapshot.data!.left,
                                      _currentScore ?? snapshot.data!.score,
                                      _currentPlayerNo ?? snapshot.data!.playerNo,
                                      _currentConnected??snapshot.data!.connected,

                                    );
                                    Navigator.of(context).pop;
                                  }
                                  //    }
                                  ),

                              SizedBox(width: 20,),

                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _currentConnected = false;
                                  });
                                  DatabaseServices(uid: user.userID)
                                      .updateUserData(
                                    _currentName ?? snapshot.data!.name,
                                    _currentTop ?? snapshot.data!.top,
                                    _currentLeft ?? snapshot.data!.left,
                                    _currentScore ?? snapshot.data!.score,
                                    _currentPlayerNo ??
                                        snapshot.data!.playerNo,
                                    _currentConnected??snapshot.data!.connected,

                                  );
                                  _authServices.signOut();
                                },
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Leave game"
                                      ,style: TextStyle(
                                        color: Colors.red[900],
                                        fontSize: 15,
                                      ),),
                                    const SizedBox(width: 5,),

                                    Icon(Icons.logout,color: Colors.red[900],size: 15,)
                                  ],
                                ),)
                              ,

                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const LoadingWidget();
                }
              }),
        ));
  }

  bool checkCollision(Gift gift, UserData userData) {
    int carLeft = _currentLeft!;
    int carTop = _currentTop!;
    int carSize = 100;

    if (gift.left + gift.size >= carLeft && gift.left <= carLeft + carSize) {
      if (gift.top >= carTop && gift.top <= carTop + carSize) {
        return true;
      }
    }

    return false;
  }

  List<Gift> gifts = [];

  late Timer timer;

  UserData tempUserData = UserData(
      uid: "43534453",
      name: "userName",
      left: 100,
      top: 100,
      score: 10,
      playerNo: 0,
      connected: true,
  );

  @override
  void initState() {
    super.initState();
    startGame(tempUserData);

  }

  void startGame(UserData userData) {
    gifts = [];

    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        // Update gift positions
        for (int i = 0; i < gifts.length; i++) {
          gifts[i].top += 25;

          if (checkCollision(gifts[i], userData)) {
            debugPrint("player hit");
            if (gifts[i].isThreat) {
              _currentScore =
                  (_currentScore - 10); // Decrease score for threats
            } else {
              _currentScore = (_currentScore + 10); // Increase score for gifts
            }
            debugPrint("player score$_currentScore");

            gifts.removeAt(i);

            setState(() {
              score_changed = true;
            });
            break;
          }

          if (gifts[i].top > 800) {
            gifts.removeAt(i);
          }
        }


        // Add new gifts randomly
        if (Random().nextInt(100) < 10) {
          int left = Random().nextInt(400);
          int size = 40 + Random().nextInt(41);
          bool isThreat = Random().nextBool();
          gifts.add(
              Gift(left: left - 100, top: 0, size: size, isThreat: isThreat));
        }
      });
    });
  }

  //     // Check game over condition
  //     if (car.score < 0) {
  //       timer.cancel();
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Game Over'),
  //             content: const Text('Your score is negative!'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   player.score = 0;
  //                   Navigator.of(context).pop();
  //                   startGame();
  //                 },
  //                 child: const Text('Restart'),
  //               ),
  //             ],
  //           );
  //         },
  //
  //
  //       );
  //     }
  //
  //
  //     // Check game winning condition
  //     if (player.score! > 200 ) {
  //       timer.cancel();
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Yaaay'),
  //             content: const Text('We have a winner!'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   player.score = 0;
  //                   Navigator.of(context).pop();
  //                   startGame();
  //                 },
  //                 child: const Text('Restart'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   });
  // }

  //
  // bool checkPlayerCollision(Player player1, Player player2) {
  //   double player1Left = player1.left!;
  //   double player1Top = player1.top!;
  //   double player2Left = player2.left!;
  //   double player2Top = player2.top!;
  //   double carSize = 120;
  //
  //   if (player1Left + carSize >= player2Left && player1Left <= player2Left + carSize) {
  //     if (player1Top + carSize >= player2Top && player1Top <= player2Top + carSize) {
  //       return true;
  //     }
  //   }
  //
  //   return false;
  // }
  //
  // void updatePlayerPositions() {
  //   if (checkPlayerCollision(player, player2)) {
  //     // Move player 2 away if collision occurs
  //     player.left = player2.left! + 75;
  //     player.top = player2.top! + 75;
  //   }
  // }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}



class UselessWidget extends StatelessWidget {
  const UselessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 0,width: 0,);
  }
}
