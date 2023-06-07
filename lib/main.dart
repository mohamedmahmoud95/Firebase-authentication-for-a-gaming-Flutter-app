


import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_auth_services/firebase_auth_services.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

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

  final AuthServices _authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          title: const Text("Car racing game"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),

        body: Center(
          child: ElevatedButton(

            child: const Text("Sign in"),
            onPressed: () async{
              debugPrint("Sign in button pressed");
              dynamic signIAnonResult = await _authServices.signInAnon();
              if (signIAnonResult == null)
                {
                  debugPrint("sign in error!");
                }
              else
                {
                  debugPrint("signed in");
                  debugPrint(signIAnonResult.toString());
                }
            },
          ),
        )
      ),
    );
  }
}
