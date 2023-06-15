import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/screens/game_screen_wrapper.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/screens/game_screen.dart';
import 'package:provider/provider.dart';
import '../firebase_services/firebase_auth_services.dart';
import '../models/user.dart';
import 'authentication_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AuthServices _authServices = AuthServices();



  @override
  Widget build(BuildContext context) {

    final AppUser? appUser = Provider.of<AppUser?>(context);

    debugPrint(appUser?.userID);

    if (appUser == null) {
      return const AuthScreen();
    }
    else
      {
        return const GameScreenWrapper();
      }
  }
}
