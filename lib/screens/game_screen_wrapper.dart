import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/firebase_auth_services.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/screens/game_screen.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/widgets/responsive.dart';
import 'package:provider/provider.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/cloud_firestore_database_services.dart';

import '../models/car.dart';
import '../models/message.dart';
class GameScreenWrapper extends StatefulWidget {
  const GameScreenWrapper({Key? key}) : super(key: key);

  @override
  State<GameScreenWrapper> createState() => _GameScreenWrapperState();
}

class _GameScreenWrapperState extends State<GameScreenWrapper> {
  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return
     MultiProvider(
        providers: [
        StreamProvider<List<Message>>.value(
        value: DatabaseServices().chatMessages,
    initialData: [],
    ),
    StreamProvider<List<Car>>.value(
    value: DatabaseServices().cars,
    initialData: [],
    ),
    ],

     child:  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text("2D Car Game"),

        ),


        body:
        // StreamProvider<List<Car>>.value(
        //   value: DatabaseServices().cars,
        //   initialData: [], // Replace null with an empty list
        //  child:

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

                      Center(
                        child: SizedBox(
                          width: width-50,
                            height: height - height / 6,
                            child: Responsive(child: GameScreen())),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
 //    ),
    );
  }
}





