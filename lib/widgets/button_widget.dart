


import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const ButtonWidget({Key? key, required this.onPressed, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){onPressed();},
        child: child,

      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Set the border radius
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Set the padding
      ),

    );
  }
}
