

import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(color: Colors.blue, width: 1)

  ),
  focusColor: Colors.blue,

);