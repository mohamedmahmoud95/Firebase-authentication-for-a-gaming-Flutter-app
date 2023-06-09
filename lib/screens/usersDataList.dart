import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';

class CarsList extends StatefulWidget {
  @override
  _CarsListState createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  @override
  Widget build(BuildContext context) {

    final cars = Provider.of<List<Car>>(context);
    for (var car in cars) {
      debugPrint(car.color.toString());
      debugPrint(car.top.toString());
      debugPrint(car.left.toString());

    }

    return Container(

    );
  }
}