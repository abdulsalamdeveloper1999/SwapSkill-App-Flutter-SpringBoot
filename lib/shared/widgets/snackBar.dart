import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

void showSnackBar(
    BuildContext context, String content, Color? backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor ?? AppTheme.primaryBlue,
      content: Text(content),
    ),
  );
}
