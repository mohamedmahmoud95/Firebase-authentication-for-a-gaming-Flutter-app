import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/models/brew.dart';

import '../models/car.dart';
import '../models/user.dart';

class DatabaseServices{

  final String? uid; //userID of the user we are updating his/her data
  DatabaseServices ({this.uid});

  //create a collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection("brews");

  Future updateUserData(String sugars, String name, int strength) async{
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //Get users' data stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map((_brewListFromSnapshot)) ;
  }


  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid!,
        name: snapshot.get('name'),
        sugars: snapshot.get('sugars'),
        strength: snapshot.get('strength'),
    );
  }


  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

  // List<Brew> _brewListFromSnapshot(QuerySnapshot<Object?> snapshot) {
  //   return snapshot.docs.map((doc) {
  //     final data = doc.data() as Map<String, dynamic>?;
  //
  //     return Brew(
  //       sugars: data?['sugars'] ?? '',
  //       name: data?['name'] ?? '',
  //       strength: data?['strength'] ?? 0,
  //     );
  //   }).toList();
  // }


  List <Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Brew(
          name: doc.get('name') ?? '',
          sugars: doc.get('sugars') ?? '0',
          strength: doc.get('strength') ?? 0
      );
    }).toList();
  }

  // // get brews stream
  // Stream<List<Brew>> get brews {
  //   return brewCollection.snapshots()
  //       .map(_brewListFromSnapshot);
  // }
  //

}

