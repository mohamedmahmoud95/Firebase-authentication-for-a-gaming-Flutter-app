import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../firebase_auth_services/firebase_auth_services.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
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
                  validator: (value) => value!.length < 6
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
                        await _authServices.signUp(email, password);
                      }
                    },
                    child: const Text("Sign Up")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
