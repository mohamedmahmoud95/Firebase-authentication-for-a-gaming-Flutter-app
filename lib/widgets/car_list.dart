import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';
import 'car_tile.dart';

class CarList extends StatefulWidget {
  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  @override
  Widget build(BuildContext context) {

    final cars = Provider.of<List<Car>>(context)??[];

    return
      SizedBox(
        height: 700,
        child: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return CarTile(car: cars[index]);
        },
    ),
      );
  }
}