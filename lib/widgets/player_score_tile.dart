import 'package:flutter/material.dart';

import '../models/car.dart';

class PlayerScoreTile extends StatelessWidget {

  final Car car;
  PlayerScoreTile({ required this.car });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
          color: Colors.blue[50],
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(car.name),
              const SizedBox(height: 5,),

              Text("${car.score }"),
            ],
          )

        ),

    );
  }
}