import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/models/user.dart';

class AuthServices {
  //an instance of the FirebaseAuth class
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Function to create a custom user from firebase user
  AppUser? _createAppUserFromFirebaseUser(User? user) {
    if (user != null) {
      return AppUser(userID: user.uid);
    }
    return null;
  }

  //Auth change user stream (to keep track of any change in authentication)
  Stream<AppUser?> get userStream {
    return _auth.authStateChanges().map(_createAppUserFromFirebaseUser);
  }

  //anonymous sign in
  Future signInAnon() async {
    try {
      UserCredential authResult = await _auth.signInAnonymously();
      final User? firebaseUser = authResult.user;
      return _createAppUserFromFirebaseUser(firebaseUser!);
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  //anonymous sign in
  Future signOut() async {
    try {
      await _auth.signOut();
      return null;
    } catch (e) {
      debugPrint("$e");
      return e;
    }
  }
}
