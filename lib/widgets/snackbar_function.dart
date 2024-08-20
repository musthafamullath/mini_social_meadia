import 'package:flutter/material.dart';
import 'package:mechine_task_cumin360/sources/constants/colors.dart';

showSnack(BuildContext context, Color color, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: white,
          letterSpacing: 1,
          wordSpacing: 1.3,
        ),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
