import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/widgets/player_score_tile.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';
import 'car_tile.dart';

class PlayersScoreList extends StatefulWidget {
  @override
  _PlayersScoreListState createState() => _PlayersScoreListState();
}

class _PlayersScoreListState extends State<PlayersScoreList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final cars = Provider.of<List<Car>>(context)??[];

    return
      SizedBox(
        height: 70,
        width: width,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return Container(
            width: width/3.5,
              child: PlayerScoreTile(car: cars[index])
          );
        },
    ),
      );
  }
}




/*
 child: Wrap(
          children: [
            ...cars.map((car) => Container(
                    width: width/3.5,
                      child: PlayerScoreTile(car: car)
                  ),
            ),

          ]
 */