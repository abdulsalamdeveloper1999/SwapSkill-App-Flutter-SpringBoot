import 'package:flutter/material.dart';

void navigator(context, Widget route) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => route,
    ),
  );
}
