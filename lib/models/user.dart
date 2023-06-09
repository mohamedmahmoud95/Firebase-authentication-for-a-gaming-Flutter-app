class AppUser {
  final String userID;

  AppUser({
    required this.userID,
  });
}

class UserData {

  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({ required this.uid, required this.sugars, required this.strength, required this.name });

}