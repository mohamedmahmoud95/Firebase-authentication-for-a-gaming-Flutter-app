import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_auth_services/firebase_auth_services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthServices _authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Auth screen"),
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
                      debugPrint("${signIAnonResult.userID}");
                    }
                  },
                ),
              )
          ),
      );
  }
}