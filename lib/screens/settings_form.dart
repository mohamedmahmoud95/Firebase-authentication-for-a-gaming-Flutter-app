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
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  final List<int> strengths = [0, 100, 200, 300, 400, 500, 600, 700, 800, 900];

  // form values
  late String _currentName ;
  late String _currentSugars ;
  late int _currentStrength ;

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
                      const Text(
                        'Update your brew settings.',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        initialValue: userData?.name,
                        decoration: textInputDecoration,
                        validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                        onChanged: (val) => setState(() => _currentName = val),
                      ),
                      SizedBox(height: 10.0),
                      DropdownButtonFormField(
                        value:  userData?.sugars,
                        decoration: textInputDecoration,
                        items: sugars.map((sugar) {
                          return DropdownMenuItem(
                            value: sugar,
                            child: Text('$sugar sugars'),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _currentSugars = val! ),
                      ),
                      const SizedBox(height: 10.0),
                      Slider(
                        value: ( userData?.strength)!.toDouble(),
                        activeColor: Colors.brown[ userData!.strength],
                        inactiveColor: Colors.brown[userData.strength],
                        min: 0.0,
                        max: 900.0,
                        divisions: 8,
                        onChanged: (val) => setState(() => _currentStrength = val.round()),
                      ),
                      ElevatedButton(
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                           // if(_formKey.currentState!.validate()){
                              await DatabaseServices(uid: user.userID).updateUserData(
                                  _currentSugars ?? snapshot.data!.sugars,
                                  _currentName ?? snapshot.data!.name,
                                  _currentStrength ?? snapshot.data!.strength
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
