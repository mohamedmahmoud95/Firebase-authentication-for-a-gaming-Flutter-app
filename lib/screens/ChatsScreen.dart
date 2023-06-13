


import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/screens/settings_form.dart';
import 'package:provider/provider.dart';

import '../firebase_services/cloud_firestore_database_services.dart';
import '../firebase_services/firebase_auth_services.dart';
import '../models/car.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../widgets/loading_widget.dart';
import '../widgets/player_score_tile.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {


  final _formKey = GlobalKey<FormState>();

  bool _showChatBottomSheet = false;

  bool score_changed = false;

  bool thereIsWinner = false;

  bool gameStarted = false;
  final AuthServices _authServices = AuthServices();



  @override
  Widget build(BuildContext context) {


    AppUser user = Provider.of<AppUser>(context);
    final cars = Provider.of<List<Car>>(context) ?? [];
    final chats = Provider.of<List<Message>>(context) ?? [];
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

    child: Material(
      child: Scaffold(


        body: Stack(
          children:[
            StreamBuilder<UserData>(
                stream: DatabaseServices(uid: user.userID).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData? userData = snapshot.data;

                    return StreamProvider<List<Message>>.value(
                      value: DatabaseServices().chatMessages,
                      initialData: [],

                      // Replace null with an empty list
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            SizedBox(
                              height: 90,
                              width: width - 50,
                              child: Container(
                                child:  Column(

                                  // ListView(
                                  // shrinkWrap: true,
                                  // scrollDirection: Axis.horizontal,
                                  //

                                  children: [


                                  // List.generate(chats.length, (index) {
                                  //   if (index >= chats.length) {
                                  //     // Handle the case where the index is out of range
                                  //     return Container();
                                  //   }
                                  //   return Container(
                                  //     width: width / cars.length,
                                  //     child: PlayerScoreTile(car: cars[index]),
                                  //   );
                                  // }
                                  // ),
                                  //

                            //
                            //     ),
                            //   ),
                            // ),






                                  ...chats.map(
                                        (chat) {return Text("${chat.message}");}
                                  ),


                            // StreamProvider<List<Message>>.value(
                            //   value: DatabaseServices().chatMessages,
                            //   initialData: [],
                            //
                            //   child: SingleChildScrollView(
                            //     child: Container(
                            //       child: Column(
                            //         children: [
                            //           ...chats.map(
                            //                   (chat) =>  ListTile(
                            //                 title: Text(chat.message),
                            //                 subtitle: Text(chat.senderName),
                            //
                            //               )
                            //
                            //           )
                            //
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                                  ),
                      ],
                      ),
                      ),
                    );
                  } else {
                    return const LoadingWidget();
                  }
                }),
          ],
        ),
      ),
    ),
    );
  }
}
