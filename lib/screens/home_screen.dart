

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase_auth_services/firebase_auth_services.dart';
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
    return const AuthScreen();
  }
}
