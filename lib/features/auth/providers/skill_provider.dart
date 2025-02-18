import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/navigator.dart';
import '../../../shared/widgets/snackBar.dart';
import '../../home/screens/home_screen.dart';
import '../repositories/skill_repo.dart';

class SkillProvider extends ChangeNotifier {
  final SkillRepository _skillRepository;
  bool _isLoading = false;
  String? _error;

  List<String> selectedTeachSkills = [];
  List<String> selectedLearnSkills = [];

  // You could move this to a separate configuration or fetch from API
  final List<String> availableSkills = [
    'Flutter',
    'React',
    'Spring Boot',
    'Node.js',
    'UI Design',
    'Python',
    'JavaScript',
    'Java',
    'Digital Marketing',
    'Content Writing',
    'SEO',
  ];

  SkillProvider(this._skillRepository);

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> addTeachingSkill(String userId, String skill) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _skillRepository.addTeachingSkill(userId, skill);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTeachSkill(String userId, String skill) async {
    try {
      // _isLoading = true;
      // _error = null;
      // notifyListeners();

      if (selectedTeachSkills.contains(skill)) {
        await _skillRepository.removeTeachingSkill(userId, skill);
        selectedTeachSkills.remove(skill);
      } else {
        await _skillRepository.addTeachingSkill(userId, skill);
        selectedTeachSkills.add(skill);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleLearnSkill(String userId, String skill) async {
    if (selectedLearnSkills.contains(skill)) {
      await _skillRepository.removeLearnSkill(userId, skill);
      selectedLearnSkills.remove(skill);
    } else {
      await _skillRepository.addLearnSkill(userId, skill);
      selectedLearnSkills.add(skill);
    }
    notifyListeners();
  }

  void getSkills(String userId) async {
    final user = await _skillRepository.getSkills(userId);

    if (user.canTeach != null && user.canTeach!.isNotEmpty) {
      selectedTeachSkills.addAll(user.canTeach!);
    }

    if (user.wantToLearn != null && user.wantToLearn!.isNotEmpty) {
      selectedLearnSkills.addAll(user.wantToLearn!);
    }

    notifyListeners();
  }

  void validateSkill(BuildContext context) {
    if (selectedLearnSkills.isEmpty) {
      showSnackBar(
        context,
        'Please select skills you want to learn.',
        AppTheme.primaryBlue,
      );
    } else if (selectedTeachSkills.isEmpty) {
      showSnackBar(
        context,
        'Please select skills you can teach.',
        AppTheme.primaryBlue,
      );
    } else {
      navigator(context, HomeScreen());
    }
  }
}
