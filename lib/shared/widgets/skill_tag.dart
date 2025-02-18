// lib/shared/widgets/skill_tag.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

enum SkillTagType { teach, learn }

class SkillTag extends StatelessWidget {
  final String skill;
  final bool isSelected;
  final VoidCallback onTap;
  final SkillTagType type;

  const SkillTag({
    super.key,
    required this.skill,
    required this.isSelected,
    required this.onTap,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isTeach = type == SkillTagType.teach;
    final backgroundColor = isSelected
        ? (isTeach ? AppTheme.teachTagBg : AppTheme.learnTagBg)
        : Colors.transparent;
    final textColor = isSelected
        ? (isTeach ? AppTheme.teachTagText : AppTheme.learnTagText)
        : AppTheme.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.borderColor,
          ),
        ),
        child: Text(
          skill,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
