import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{

  final String uid; //userID of the user we are updating his/her data
  DatabaseServices ({required this.uid});

  //create a collection reference
  final CollectionReference usersDataCollection = FirebaseFirestore.instance.collection("users");

  Future updateUserData(String name, int top, int left, int score) async{
    return await usersDataCollection.doc(uid).set({
      'name': name,
      'top': top,
      'left': left,
      'score': score,
    }
    );
  }
}