import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/cloud_firestore_database_services.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/car.dart';
import '../models/user.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String? _currentName;
  int? _currentTop;
  int? _currentLeft;
  int? _currentScore;
  int? _currentPlayerNo;

  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);
    final cars = Provider.of<List<Car>>(context) ?? [];
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<UserData>(
            stream: DatabaseServices(uid: user.userID).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData? userData = snapshot.data;

                return StreamProvider<List<Car>>.value(
                  value: DatabaseServices().cars,
                  initialData: [], // Replace null with an empty list
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextFormField(
                          initialValue: userData?.name,
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
                              ...cars.map((car) => Positioned(
                                  left: car.left.toDouble(),
                                  top: car.top.toDouble(),
                                  child: GestureDetector(
                                    onPanUpdate: (newPosition) {
                                      setState(() {
                                        _currentLeft = max(
                                                0,
                                                (_currentLeft ?? 0) +

                                                    ( newPosition.delta.dx )
                                        )
                                            .round();
                                        _currentTop = max(
                                                0,
                                                (_currentTop ?? 0) +
                                                    newPosition.delta.dy)
                                            .round();

                                      });

                                      DatabaseServices(uid: user.userID)
                                          .updateUserData(
                                        _currentName ?? snapshot.data!.name,
                                        _currentTop ?? snapshot.data!.top,
                                        _currentLeft ?? snapshot.data!.left,
                                        _currentScore ?? snapshot.data!.score,
                                        _currentPlayerNo ??
                                            snapshot.data!.playerNo,
                                      );
                                    },
                                    child: Container(
                                      color: Colors.blue,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ))),
                            ],
                          ),
                        ),

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           ElevatedButton(onPressed: (){
                             setState(() {
                               _currentLeft = max(
                                   0,
                                   (_currentLeft ?? 0) - 40
                               );

                               DatabaseServices(uid: user.userID)
                                   .updateUserData(
                                 _currentName ?? snapshot.data!.name,
                                 _currentTop ?? snapshot.data!.top,
                                 _currentLeft ?? snapshot.data!.left,
                                 _currentScore ?? snapshot.data!.score,
                                 _currentPlayerNo ??
                                     snapshot.data!.playerNo,
                               );

                             });
                           },
                               child: Icon(Icons.arrow_back)),
                           ElevatedButton(onPressed: (){
                             setState(() {
                               _currentLeft = max(
                                   0,
                                   (_currentLeft ?? 0) + 40
                               );

                               DatabaseServices(uid: user.userID)
                                   .updateUserData(
                                 _currentName ?? snapshot.data!.name,
                                 _currentTop ?? snapshot.data!.top,
                                 _currentLeft ?? snapshot.data!.left,
                                 _currentScore ?? snapshot.data!.score,
                                 _currentPlayerNo ??
                                     snapshot.data!.playerNo,
                               );

                             });
                           }, child: Icon(Icons.arrow_forward)),
                         ],
                       ),
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
                              );
                              Navigator.of(context).pop;
                            }
                            //    }
                            ),
                      ],
                    ),
                  ),
                );
              } else {
                return LoadingWidget();
              }
            }));
  }
}
