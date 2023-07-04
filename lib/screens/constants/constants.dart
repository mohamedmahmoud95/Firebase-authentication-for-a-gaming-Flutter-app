

import 'package:flutter/material.dart';

InputDecoration textInputDecoration = InputDecoration(

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
  focusColor: Colors.blue,
);