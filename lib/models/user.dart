class AppUser {
  final String userID;

  AppUser({
    required this.userID,
  });
}

class UserData {
  int left;
  int top;
  int score;
  int playerNo;

  final String uid;
  final String name;

  UserData(
      {required this.uid,
      required this.name,
      required this.left,
      required this.top,
      required this.score,
      required this.playerNo});
}
