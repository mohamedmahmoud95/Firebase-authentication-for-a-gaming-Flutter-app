import 'package:flutter/material.dart';

import '../models/car.dart';

class CarTile extends StatelessWidget {

  final Car car;
  CarTile({ required this.car });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.blue[50],
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Column(
          children: [
            Text("Player name: ${car.name }"),
            const SizedBox(height: 5,),

            Text("Top Position: ${car.top }"),
            const SizedBox(height: 5,),

            Text("Left Position: ${car.left }"),
            const SizedBox(height: 5,),

            Text("Score: ${car.score }"),
            const SizedBox(height: 5,),
          ],
        )


        // ListTile(
        //   leading: CircleAvatar(
        //     radius: 25.0,
        //   ),
        //   title: Text(brew.name),
        //   subtitle: Text('got ${brew.score} point(s)'),
        // ),
      ),
    );
  }
}