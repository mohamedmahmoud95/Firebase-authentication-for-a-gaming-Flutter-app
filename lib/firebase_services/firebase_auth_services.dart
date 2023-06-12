import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/cloud_firestore_database_services.dart';
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


  //Sign up with email and password
  Future signUp(String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = authResult.user;

      debugPrint("New user added to firebase!");

      //Create a Firestore cloud database collection doc with initial data
      DatabaseServices(uid: firebaseUser?.uid).updateUserData( 'userName', 100, 100, 0, 0);
      debugPrint("Database collection doc created!");
      return _createAppUserFromFirebaseUser(firebaseUser);
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }


  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = authResult.user;
      return _createAppUserFromFirebaseUser(firebaseUser!);
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }


  //sign out
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
