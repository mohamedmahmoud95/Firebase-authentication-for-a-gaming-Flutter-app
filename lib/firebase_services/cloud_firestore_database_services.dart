import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/models/car.dart';

import '../models/car.dart';
import '../models/user.dart';

class DatabaseServices {
  final String? uid; //userID of the user we are updating his/her data
  DatabaseServices({this.uid});

  //create a collection reference
  final CollectionReference carCollection =
  FirebaseFirestore.instance.collection("cars");

  Future updateUserData(String name, int top,
      int left, int score, int playerNo, bool connected) async {
    return await carCollection.doc(uid).set({
      'name': name,
      'top': top,
      'left': left,
      'score': score,
      'playerNo': playerNo,
      'connected': connected,
    });
  }

  Future updateConnectedStatus(bool connected) async {
    return await carCollection.doc(uid).update({
      'connected': connected,
    });
  }


  //Get users' data stream
  Stream<List<Car>> get cars {
    return carCollection.snapshots().map((_carListFromSnapshot));
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid!,
      name: snapshot.get('name'),
      top: snapshot.get('top'),
      left: snapshot.get('left'),
      score: snapshot.get('score'),
      playerNo: snapshot.get('playerNo'),
      connected: snapshot.get('connected'),
    );
  }


  // get user doc stream
  Stream<UserData> get userData {
    return carCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }


  List<Car> _carListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final doc = entry.value;

      return Car(
        name: doc.get('name') ?? '',
        top: doc.get('top') ?? 300,
        left: doc.get('left') ?? 200,
        score: doc.get('score') ?? 0,
        connected: doc.get('connected')?? true,
        playerNo: index,
      );
    }).toList();
  }

// List<Car> _carListFromSnapshot(QuerySnapshot snapshot) {
//   return snapshot.docs.map((doc) {
//     return Car(
//         name: doc.get('name') ?? '',
//         top: doc.get('top')?? 500,
//         left: doc.get('left') ?? 100,
//         score: doc.get('score')?? 0,
//         playerNo: doc.get('playerNo')?? 0,
//     );
//   }).toList();
//}
}
