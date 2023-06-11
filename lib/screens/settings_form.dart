import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/cloud_firestore_database_services.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/user.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();


  // form values
   String? _currentName ;
   int? _currentTop;
   int? _currentLeft;
   int? _currentScore;
   int? _currentPlayerNo;

  @override
  Widget build(BuildContext context) {

    AppUser user = Provider.of<AppUser>(context);

    return MaterialApp(
        home: StreamBuilder<UserData>(
            stream: DatabaseServices(uid: user.userID).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData? userData = snapshot.data;

               return Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[

                      TextFormField(
                        initialValue: userData?.name,
                        decoration: textInputDecoration,
                   //     validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                        onChanged: (val) => setState(() => _currentName = val),
                      ),

                    //   const SizedBox(height: 20.0),
                    //   TextFormField(
                    //     initialValue: userData?.left.toString(),
                    //     decoration: textInputDecoration,
                    // //    validator: (val) => val!.isEmpty ? 'Please enter left position' : null,
                    //     onChanged: (val) => setState(() => _currentLeft = int.parse(val)),
                    //   ),
                    //
                    //
                    //   const SizedBox(height: 20.0),
                    //   TextFormField(
                    //     initialValue: userData?.top.toString(),
                    //     decoration: textInputDecoration,
                    // //    validator: (val) => val!.isEmpty ? 'Please enter top position' : null,
                    //     onChanged: (val) => setState(() => _currentTop = int.parse(val)),
                    //   ),


                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Stack(
                          children: [

                            Positioned(
                              left: _currentLeft?.toDouble(),
                                top: _currentTop?.toDouble(),

                                child:
                                GestureDetector(
                                  onPanUpdate: (newPosition){
                                    setState(() {
                                      _currentLeft = max(0, (_currentLeft ?? 0) + newPosition.delta.dx).round();
                                      _currentTop = max(0, (_currentTop ?? 0) + newPosition.delta.dy).round();

                                      debugPrint("_currentLeft = ${_currentLeft}");
                                      debugPrint("_currentTop = ${_currentTop}");
                                    });
                                        //   () async {
                                        // // if(_formKey.currentState!.validate()){
                                        // await
                                        DatabaseServices(uid: user.userID).updateUserData(
                                          _currentName ?? snapshot.data!.name,
                                          _currentTop ?? snapshot.data!.top,
                                          _currentLeft ?? snapshot.data!.left,
                                          _currentScore ?? snapshot.data!.score,
                                          _currentPlayerNo ?? snapshot.data!.playerNo,

                                        );
                                         Navigator.of(context).pop;

                                   //   };




                                  },

                                  child: Container(
                                    color: Colors.blue,
                                    height: 50,
                                    width: 50,
                                  ),
                                )
                            )
                          ],
                        ),

                      ),

                      const SizedBox(height: 20.0),
                      TextFormField(

                        initialValue: userData?.score.toString(),
                        decoration: textInputDecoration,
                       // validator: (val) => val!.isEmpty ? 'Please enter score' : null,
                        onChanged: (val) => setState(() => _currentScore = int.parse(val)),
                      ),

                      const SizedBox(height: 10.0),


                      ElevatedButton(
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),

                          onPressed: () async {
                           // if(_formKey.currentState!.validate()){
                              await DatabaseServices(uid: user.userID).updateUserData(
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
               );
              } else {
                return LoadingWidget();
              }
            }));
  }
}
