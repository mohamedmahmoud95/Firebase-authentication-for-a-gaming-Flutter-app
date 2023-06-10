import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/firebase_auth_services.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/screens/settings_form.dart';
import 'package:provider/provider.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/cloud_firestore_database_services.dart';

import '../models/car.dart';
import '../widgets/car_list.dart';
import '../widgets/players_score_list.dart';
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AuthServices _authServices = AuthServices();

  void _showSettingsPanel() {
    showModalBottomSheet(context: context,
        builder: (context) {
      return Container(
        height: 600,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: SettingsForm(),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Game screen"),
          actions: [
            IconButton(
              onPressed: () {
                _authServices.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showSettingsPanel(),
            ),
          ],
        ),
        body: StreamProvider<List<Car>>.value(
          value: DatabaseServices().cars,
          initialData: [], // Replace null with an empty list
          child:

          Container(
            height: 700,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: [
                        Card(
                          child: Container(
                            height: 75,
                            child: PlayersScoreList(),
                          ),
                        ),
                        CarList(),
                      ],
                    ),
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





