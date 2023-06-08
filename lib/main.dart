import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/firebase_auth_services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/user.dart';

void main ()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
final AuthServices _auth = AuthServices();
@override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
        value: AuthServices().userStream,
        initialData: null,
        child: const HomeScreen());
  }
}
