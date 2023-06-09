import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/firebase_auth_services.dart';
import 'package:provider/provider.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/cloud_firestore_database_services.dart';

import '../models/brew.dart';
import '../widgets/brew_list.dart';
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AuthServices _authServices = AuthServices();
  @override
  Widget build(BuildContext context)
  {
    BrewList();
    return
    //   StreamProvider<List<Brew>>.value(
    //   value: DatabaseService().brews,
    // initialData: DatabaseServices().brewCollection,
    // child:
    StreamProvider<List<Brew>>.value(
      value: DatabaseServices().brews,
      initialData: [],
      child: MaterialApp(
        home: Scaffold(
          // MaterialApp(
          // debugShowCheckedModeBanner: false,
          // home: Scaffold(
            appBar: AppBar(title: const Text("Game screen"),
            actions: [
              IconButton(onPressed: (){
                _authServices.signOut();
              },
                  icon: const Icon(Icons.logout)),

            ],
            ),
 body: BrewList(),

 //     ),
        ),
      ),
    );
  }
}




/*
For those who has error in initialData couldn't be null
1. watch the next video first
2. then replace the function _brewListFromSnapshot in database service file  with

List <Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
     return snapshot.docs.map((doc){
       return Brew(
         name: doc.get('name') ?? '',
         sugars: doc.get('sugars') ?? '0',
         strength: doc.get('strength') ?? 0
       );
     }).toList();
  }
3. put initial Data like this
initialData: [],
 */