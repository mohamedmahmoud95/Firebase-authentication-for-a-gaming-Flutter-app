import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_auth_services/firebase_auth_services.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback toggleShow;

  const SignInScreen({Key? key, required this.toggleShow}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthServices _authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Sign In"),
          actions: [
            IconButton(
                onPressed: () => widget.toggleShow(),
                icon: const Icon(Icons.app_registration)
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ElevatedButton(

                child: const Text("Sign in anonymously"),
                onPressed: () async{
                  debugPrint("Sign in anonymously button pressed");
                  dynamic signIAnonResult = await _authServices.signInAnon();
                  if (signIAnonResult == null)
                  {
                    debugPrint("sign in error!");
                  }
                  else
                  {
                    debugPrint("signed in anonymously");
                    debugPrint("${signIAnonResult.userID}");
                  }
                },
              ),
            ],
          ),
        ),

      ),
    );
  }
}
