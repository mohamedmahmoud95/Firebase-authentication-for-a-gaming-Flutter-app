import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/firebase_services/firebase_auth_services.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/widgets/loading_widget.dart';

import '../constants/constants.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback toggleShow;

  const SignInScreen({Key? key, required this.toggleShow}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthServices _authServices = AuthServices();

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return const LoadingWidget();
    }
    else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Sign In"),
            actions: [
              IconButton(
                  onPressed: () => widget.toggleShow(),
                  icon: const Icon(Icons.app_registration))
            ],
          ),
          body: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined)),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                      value!.isEmpty ? "Required field is empty!" : null,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.key)),
                      validator: (value) =>
                      value!.length < 6
                          ? "Password must be at least 6 characters!"
                          : null,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic signInResult = await _authServices
                                .signInWithEmailAndPassword(
                                email, password);
                            if (signInResult == null) {
                              debugPrint("sign in error!");
                              setState(() {
                                loading = false;
                              });
                            };
                          }
                        },

                        child: const Text("Sign In")),
                        const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: const Text("Sign in anonymously"),
                      onPressed: () async {
                        debugPrint("Sign in anonymously button pressed");
                        setState(() {
                          loading = true;
                        });
                        dynamic signIAnonResult =
                        await _authServices.signInAnon();
                        if (signIAnonResult == null) {
                          debugPrint("sign in error!");
                          setState(() {
                            loading = false;
                          });
                        } else {
                          debugPrint("signed in anonymously");
                          debugPrint("${signIAnonResult.userID}");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}