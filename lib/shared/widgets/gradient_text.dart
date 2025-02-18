import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;

  const GradientText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          AppTheme.primaryBlue,
          AppTheme.primaryPurple,
        ],
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 28,
          fontWeight: fontWeight ?? FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
