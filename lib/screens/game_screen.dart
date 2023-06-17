import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/cloud_firestore_database_services.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/widgets/button_widget.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../firebase_services/firebase_auth_services.dart';
import '../models/car.dart';
import '../models/gift.dart';
import '../models/message.dart';
import '../models/road.dart';
import '../models/user.dart';
import '../widgets/message_bubble.dart';
import '../widgets/player_score_tile.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  TextEditingController _textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  int totalWidth = 400;
  // form values
  String _currentName = '';
  int _currentTop = 300;
  int _currentLeft = 200;
  int _currentScore = 0;
  int _currentPlayerNo = 0;
  bool _currentConnected = true;
  String _winnerName = '';
  bool score_changed = false;

  String _initialUserName  = '';
  bool thereIsWinner = false;    //to End game and navigate out
  bool nameIsSubmitted = false;  //to delete the name input field when submitted

  bool gameStarted = false;
  final AuthServices _authServices = AuthServices();


  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);
    final cars = Provider.of<List<Car>>(context) ?? [];
    final chats = Provider.of<List<Message>>(context) ?? [];
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    totalWidth = width.toInt();

    return Scaffold(
      body: Stack(
        children: [

          StreamBuilder<UserData>(
              stream: DatabaseServices(uid: user.userID).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData? userData = snapshot.data;

                  _initialUserName = userData!.name;
                  _currentLeft = userData.left;
                  _currentTop = userData.top;


                  tempUserData = userData;

                  if (_currentName == '' && _currentScore == 0) {
                    _currentName = snapshot.data!.name;
                    _currentScore = snapshot.data!.score;
                  }

                  if (thereIsWinner == true && score_changed == true) {
                    DatabaseServices().resetScores();
                    DatabaseServices().deleteAllChats();
                   // DatabaseServices().updateConnectedStatus(false);
                    DatabaseServices().disconnectAll();
                    WinnerDialog();
                   // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>WinnerDialog()));
                    //code to navigate to winner screen
                  }

                  if (score_changed == true) {
                    DatabaseServices(uid: user.userID).updateUserData(
                      _currentName ?? snapshot.data!.name,
                      _currentTop ?? snapshot.data!.top,
                      _currentLeft ?? snapshot.data!.left,
                      _currentScore ?? snapshot.data!.score,
                      _currentPlayerNo ?? snapshot.data!.playerNo,
                      _currentConnected ?? snapshot.data!.connected,
                    );
                    score_changed = false;
                  }

                  return StreamProvider<List<Car>>.value(
                    value: DatabaseServices().cars,
                    initialData: [],

                    // Replace null with an empty list
                    child: thereIsWinner
                        ? WinnerDialog()
                        : Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[



                                  updateCarsList(cars),

                                  SizedBox(
                                    height: 90,
                                    width: width - 50,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(cars.length, (index) {
                                          if (index >= cars.length) {
                                            // Handle the case where the index is out of range
                                            return Container();
                                          }
                                          return Container(
                                            width: 150,
                                            child: PlayerScoreTile(car: cars[index]),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),


                                  nameIsSubmitted ?
                                  const EmptyWidget() : nameTextField(),




                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                                    child: SizedBox(
                                      height: height / 2,
                                      width: width - 50,
                                      child: Stack(
                                        children: [




                                          ...roads.map(
                                                (road) => Positioned(
                                              left: 0,
                                              top: road.top.toDouble(),
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 200, child: Image.asset("assets/road.png",)),
                                                    SizedBox(width: 200, child: Image.asset("assets/road.png",)),
                                                    SizedBox(width: 200, child: Image.asset("assets/road.png",)),
                                                  ],
                                                )
                                              ),
                                            ),
                                          ),


                                          ...gifts.map(
                                            (gift) => Positioned(
                                              left: gift.left.toDouble(),
                                              top: gift.top.toDouble(),
                                              child: Container(
                                                width: gift.size.toDouble(),
                                                height: gift.size.toDouble(),
                                                child: gift.isThreat
                                                    ? Image.asset(
                                                        'assets/threat.png')
                                                    : Image.asset(
                                                        'assets/health.png'),
                                              ),
                                            ),
                                          ),


                                          updateCarsList(cars),
                                          checkForWinner(cars),


                                          ...cars.map(
                                            (car) => car.connected == false
                                                ? const EmptyWidget()
                                                : Positioned(
                                                    left: car.left.toDouble(),
                                                    top: car.top.toDouble(),
                                                    child: GestureDetector(
                                                      onPanUpdate: (newPosition) {
                                                        setState(() {
                                                          gameStarted = true;

                                                          _currentLeft = max(
                                                                  0,
                                                                  (_currentLeft ??
                                                                          0) +
                                                                      (newPosition
                                                                          .delta
                                                                          .dx))
                                                              .round();
                                                          if (_currentLeft! >
                                                          (width - 100)) {
                                                          _currentLeft =
                                                          (width - 100)
                                                              .toInt();
                                                          }
                                                          _currentTop = max(
                                                          0,
                                                          (_currentTop ??
                                                          0) +
                                                          newPosition
                                                              .delta
                                                              .dy)
                                                              .round();
                                                          if (_currentTop>
                                                              (width - 100)) {
                                                            _currentLeft =
                                                                (width - 100)
                                                                    .toInt();
                                                          }
                                                          _currentTop = max(
                                                                  0,
                                                                  (_currentTop ??
                                                                          0) +
                                                                      newPosition
                                                                          .delta
                                                                          .dy)
                                                              .round();
                                                          if (_currentTop >
                                                              ((height / 2)-80)) {
                                                            _currentTop =
                                                            ((height / 2)-80).toInt();
                                                          }
                                                        });

                                                        if (_currentScore == 0) {
                                                          _currentScore = snapshot
                                                              .data!.score;
                                                        }

                                                        DatabaseServices(
                                                                uid: user.userID)
                                                            .updateUserData(
                                                          _currentName ??
                                                              snapshot.data!.name,
                                                          _currentTop ??
                                                              snapshot.data!.top,
                                                          _currentLeft ??
                                                              snapshot.data!.left,
                                                          _currentScore ??
                                                              snapshot
                                                                  .data!.score,
                                                          _currentPlayerNo ??
                                                              snapshot
                                                                  .data!.playerNo,
                                                          _currentConnected ??
                                                              snapshot.data!
                                                                  .connected,
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 75,
                                                        width: 75,
                                                        child: Image.asset(
                                                            'assets/car_${car.playerNo}.png'),
                                                      ),
                                                    )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),


                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ButtonWidget(
                                          onPressed: () {
                                            setState(() {
                                              _currentLeft = max(
                                                  0, (_currentLeft ?? 0) - 40);
                                            });
                                            DatabaseServices(uid: user.userID)
                                                .updateUserData(
                                              _currentName ??
                                                  snapshot.data!.name,
                                              _currentTop ?? snapshot.data!.top,
                                              _currentLeft ??
                                                  snapshot.data!.left,
                                              _currentScore ??
                                                  snapshot.data!.score,
                                              _currentPlayerNo ??
                                                  snapshot.data!.playerNo,
                                              _currentConnected ??
                                                  snapshot.data!.connected,
                                            );
                                          },
                                          child: const Icon(Icons.arrow_back)),


                                      ButtonWidget(
                                          onPressed: () {
                                            setState(() {
                                              _currentLeft = max(
                                                  0, (_currentLeft ?? 0) + 40);
                                              if (_currentLeft! >
                                                  (width - 100)) {
                                                _currentLeft =
                                                    (width - 100).toInt();
                                              }
                                            });

                                            DatabaseServices(uid: user.userID)
                                                .updateUserData(
                                              _currentName ??
                                                  snapshot.data!.name,
                                              _currentTop ?? snapshot.data!.top,
                                              _currentLeft ??
                                                  snapshot.data!.left,
                                              _currentScore ??
                                                  snapshot.data!.score,
                                              _currentPlayerNo ??
                                                  snapshot.data!.playerNo,
                                              _currentConnected ??
                                                  snapshot.data!.connected,
                                            );
                                          },
                                          child:
                                              const Icon(Icons.arrow_forward)),
                                    ],
                                  ),


                                   Container(color: Colors.white, height: 10,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      ElevatedButton(

                                        onPressed: () {
                                          setState(() {
                                            _currentConnected = false;
                                            _currentScore = 0;
                                          });
                                          DatabaseServices(uid: user.userID)
                                              .updateUserData(
                                            _currentName ?? snapshot.data!.name,
                                            _currentTop ?? snapshot.data!.top,
                                            _currentLeft ?? snapshot.data!.left,
                                            _currentScore ??
                                                snapshot.data!.score,
                                            _currentPlayerNo ??
                                                snapshot.data!.playerNo,
                                            _currentConnected ??
                                                snapshot.data!.connected,
                                          );

                                          for (Car car in cars) {
                                            debugPrint("${car.name}   ");
                                          }

                                          _authServices.signOut();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white
                                        ),


                                        child:
                                            Text(
                                              "Leave game",
                                              style: TextStyle(
                                                color: Colors.red[900],
                                                fontSize: 15,
                                              ),
                                            ),
                                      ),


                                            const SizedBox(width: 150,),

                                            FloatingActionButton(
                                              backgroundColor: Colors.white,
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return StreamProvider<
                                                        List<Message>>.value(
                                                      value: DatabaseServices()
                                                          .chatMessages,
                                                      initialData: [],
                                                      child: Consumer<
                                                          List<Message>>(
                                                        builder: (context,
                                                            chats, _) {
                                                          return SingleChildScrollView(
                                                            child: Container(
                                                              color: Colors
                                                                  .grey[200],
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
                                                                  height:
                                                                      height /
                                                                          2,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        ...chats
                                                                            .map(
                                                                              (chat) => MessageBubble(
                                                                                message: chat,
                                                                                senderName: chat.senderName,
                                                                                isMe: chat.senderName == userData.name ? true : false,
                                                                              ),
                                                                            )
                                                                            .toList(),
                                                                        const SizedBox(
                                                                            height:
                                                                                20.0),
                                                                        SizedBox(
                                                                          width: width - 200,
                                                                          height: 65,
                                                                          child: TextField(
                                                                            controller:
                                                                                _textEditingController,
                                                                            decoration:
                                                                                InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(30.0),

                                                                                  ),// Adjust the value as needed
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(30.0),
                                                                                  ),//
                                                                                    suffix: IconButton(
                                                                                  onPressed: () {
                                                                                    String message = _textEditingController.text.trim();
                                                                                    if (message.isNotEmpty) {
                                                                                      String senderName = userData.name;
                                                                                      DatabaseServices().sendChatMessage(message, senderName);
                                                                                      _textEditingController.clear();
                                                                                    }
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons.send,
                                                                                    color: Colors.blue[900],
                                                                                  )),
                                                                              labelText:
                                                                                  'New Message',
                                                                            ),
                                                                            onSubmitted:
                                                                                (value) {
                                                                              String
                                                                                  message =
                                                                                  _textEditingController.text.trim();
                                                                              if (message.isNotEmpty) {
                                                                                String senderName = userData.name;
                                                                                DatabaseServices().sendChatMessage(message, senderName);
                                                                                _textEditingController.clear();
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child:
                                                   Icon(Icons.chat_rounded, color: Colors.blue[900],)
                                            ),
                                          ],
                                        ),

                                    ],
                                  ),

                              ),
                            ),
                          );

                } else {
                  return const LoadingWidget();
                }
              }),
        ],
      ),
    );
  }



  Widget nameTextField () {
    return   TextFormField(
      decoration: textInputDecoration.copyWith(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),//

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),//

        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.blue),
          borderRadius: BorderRadius.circular(30.0),
        ),

        label: const Text("Your name"),
        hintText: "Your name",

        prefixIcon: const Icon(Icons.person),
        suffixIcon:  IconButton(
            onPressed:  (){ setState(() => nameIsSubmitted = true);},
            icon: const Icon(Icons.done)),
      ),

      initialValue: _initialUserName,
      onChanged: (val) =>
          setState(() => _currentName = val),

      onFieldSubmitted: (val){
        setState(() {
          _currentName = val;
        });
      },
    );
  }

  //if a player is disconnected, remove his car from the UI
  Widget updateCarsList(List<Car> cars) {
    cars.removeWhere((car) => !car.connected);
    return const SizedBox(height: 0, width: 0);
  }



  //Check if a car hit a gift/threat
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

  List<Road> roads = [];

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

    roads.add(Road( top: -500));
    roads.add(Road( top: -400));
    roads.add(Road( top: -300));
    roads.add(Road( top: -200));
    roads.add(Road( top: -100));
    roads.add(Road( top: 0));
    roads.add(Road( top: 100));
    roads.add(Road( top: 200));
    roads.add(Road( top: 300));
    roads.add(Road( top: 400));
    roads.add(Road( top: 500));
    roads.add(Road( top: 600));
    roads.add(Road( top: 700));

    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        // Update gift positions

        for (int i = 0; i < roads.length; i++)
      {
        roads[i].top += 25;
      }

        if (timer.tick%4 == 0)
        {roads.add(Road(top: -200));}


          for (int i = 0; i < gifts.length; i++) {
          gifts[i].top += 25;


          if (checkCollision(gifts[i], userData)) {
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

          if (roads[i].top > 800) {
            roads.removeAt(i);
          }
        }
        // Add new gifts randomly
        if (Random().nextInt(100) < 10) {
          int size = 40 + Random().nextInt(20);
          int left = ((size * 2) + Random().nextInt((totalWidth - (size * 2))))
              .toInt();
          bool isThreat = Random().nextBool();
          gifts.add(
              Gift(left: left - 100, top: 0, size: size, isThreat: isThreat));


        }
      });
    });
  }


  Widget checkForWinner(List<Car> cars) {
    for (Car car in cars) {
      // Check game winning condition
      if (car.score > 30) {
        timer.cancel();
        // for (Car car in cars) {
        //   car.score = 0;
        // }

        _currentScore = 0;
        score_changed = true;
        thereIsWinner = true;
        _currentConnected = false;
        _winnerName = car.name;
      }
    }
    return Container();
  }

  Widget WinnerDialog() => AlertDialog(
    title: const Text('Yaaay', style: TextStyle(fontSize: 24)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('We have a winner!\n congrats $_winnerName',
            style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            thereIsWinner = false;
            DatabaseServices().deleteAllChats();
            _authServices.signOut();
          },
          child: const Text("Leave game", style: TextStyle(fontSize: 18)),
        ),
      ],
    ),
      );

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 0,
      width: 0,
    );
  }
}
