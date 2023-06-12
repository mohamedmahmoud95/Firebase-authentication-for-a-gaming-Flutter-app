import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/firebase_auth_services.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/screens/settings_form.dart';
import 'package:provider/provider.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/cloud_firestore_database_services.dart';

import '../models/car.dart';
import '../widgets/players_score_list.dart';
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AuthServices _authServices = AuthServices();

  // void _showSettingsPanel() {
  //   showModalBottomSheet(context: context,
  //       builder: (context) {
  //     return Container(
  //       height: 600,
  //       padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
  //       child: SettingsForm(),
  //     );
  //   });
  // }


  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text("Game screen"),
          actions: [
            IconButton(
              onPressed: () {
                _authServices.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
            // IconButton(
            //   icon: const Icon(Icons.settings),
            //   onPressed: () => _showSettingsPanel(),
            // ),
          ],
        ),

        body: StreamProvider<List<Car>>.value(
          value: DatabaseServices().cars,
          initialData: [], // Replace null with an empty list
          child:

          Container(
            height: height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 0, // Replace with your desired minimum height
                      maxHeight: height , // Replace with your desired maximum height
                      minWidth: 0, // Replace with your desired minimum width
                      maxWidth: width, // Replace with your desired maximum width
                    ),
                    child: // Your child widget here

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Card(
                      //   child: Container(
                      //     height: 75,
                      //     width: width ,
                      //     child: PlayersScoreList(),
                      //   ),
                      // ),
                   //   CarList(),
                      Center(
                        child: SizedBox(
                          width: width-50,
                            height: height - height / 4,
                            child: SettingsForm()),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}





