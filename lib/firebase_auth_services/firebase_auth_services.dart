


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/models/user.dart';

class AuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Creating an instance of the FirebaseAuth class

  //Function to create a custom user from firebase user


  //anonymous sign in
  Future signInAnon() async{

    try{
      UserCredential authResult = await _auth.signInAnonymously();
      final User? firebaseUser = authResult.user;
      return firebaseUser;
    }catch(e){
      debugPrint("$e");
      return null;
    }

  }




}