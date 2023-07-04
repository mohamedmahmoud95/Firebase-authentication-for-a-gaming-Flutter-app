import 'package:flutter/material.dart';

import '../firebase_services/firebase_auth_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/button_widget.dart';
import '../widgets/loading_widget.dart';
import 'constants/constants.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback toggleShow;
  const SignUpScreen({Key? key, required this.toggleShow}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
            backgroundColor: Colors.blue[900],

            title: const Text("Sign Up"),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.toggleShow();
                    });
                  },
                  icon: const Icon(Icons.login)),
            ],
          ),
          body: Form(
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),

                          ),// Adjust the value as needed
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),//

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: "Email",
                        label: const Text("Email"),
                        prefixIcon: const Icon(Icons.email_outlined),
                        focusColor: Colors.blue.shade900,

                    ),

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
                    height: 30,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),//
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),//

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(30.0),
                        ),

                        hintText: "Password",
                        label: const Text("Password"),
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
                    height: 30,
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Set the border radius
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Set the padding
                    ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic authResult = await _authServices.signUp(email, password);
                          if (authResult == null) {
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      },
                      child: const Text("Sign Up", style: TextStyle(fontSize: 16),)),

                  const SizedBox(height: 30,),


                  ButtonWidget(
                    child: const Text("Continue with Google"),
                    onPressed:  () async {
                      debugPrint("Continue with Google button pressed");
                      setState(() {
                        loading = true;
                      });
                      // dynamic signIAnonResult =
                      // await _authServices.signInAnon();
                      // if (signIAnonResult == null) {
                      //   debugPrint("sign in error!");
                      //   setState(() {
                      //     loading = false;
                      //   });
                      // } else {
                      //   debugPrint("signed in with Google");
                      //   debugPrint("${signIAnonResult.userID}");
                      // }
                    },
                  ),

                  const SizedBox(height: 30,),


                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ", style: TextStyle(fontSize: 16),),
                      TextButton(onPressed: (){
                        widget.toggleShow();
                      }, child: const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
