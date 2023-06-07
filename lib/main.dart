


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main () {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
            onPressed: (){
              debugPrint("Sign in button pressed");
              debugPrint("user id: ");
            },
          ),
        )
      ),
    );
  }
}
