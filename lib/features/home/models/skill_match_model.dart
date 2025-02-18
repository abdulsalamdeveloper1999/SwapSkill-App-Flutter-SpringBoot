// lib/features/home/models/skill_match_model.dart
class SkillMatch {
  final String id;
  final String username;
  final String? avatar;
  final List<String> canTeach;
  final List<String> wantToLearn;
  final double rating;
  final int matchPercentage;

  SkillMatch({
    required this.id,
    required this.username,
    required this.canTeach,
    required this.wantToLearn,
    this.avatar,
    required this.rating,
    required this.matchPercentage,
  });
}
