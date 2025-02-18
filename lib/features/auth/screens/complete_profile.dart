// ignore_for_file: public_member_api_docs, sort_constructors_first
// lib/features/profile/screens/complete_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skill_swap_with_spring/features/home/screens/home_screen.dart';
import 'package:skill_swap_with_spring/shared/widgets/navigator.dart';
import 'package:skill_swap_with_spring/shared/widgets/snackBar.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/skill_tag.dart';
import '../providers/auth_provider.dart';
import '../providers/skill_provider.dart';

class CompleteProfileScreen extends StatefulWidget {
  final bool fromLogin;
  const CompleteProfileScreen({
    super.key,
    required this.fromLogin,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late final AuthProvider _authProvider;
  late final SkillProvider _skillProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    _skillProvider = context.read<SkillProvider>();
    _skillProvider.getSkills(_authProvider.user!.id!);
  }

  // Sample skill categories - in real app, fetch from API
  final List<String> _availableSkills = [
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

  void validateSkill() {
    if (_skillProvider.selectedLearnSkills.isEmpty) {
      showSnackBar(
        context,
        'Please select skills you want to learn.',
        AppTheme.primaryBlue,
      );
    } else if (_skillProvider.selectedTeachSkills.isEmpty) {
      showSnackBar(
        context,
        'Please select skills you can teach.',
        AppTheme.primaryBlue,
      );
    } else {
      widget.fromLogin
          ? navigator(context, HomeScreen())
          : Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete Your Profile',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              Text(
                'What skills can you teach?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Consumer<SkillProvider>(builder: (context, skillProvider, child) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skillProvider.availableSkills.map((skill) {
                    final isSelected =
                        skillProvider.selectedTeachSkills.contains(skill);
                    return SkillTag(
                      skill: skill,
                      isSelected: isSelected,
                      onTap: () async {
                        final userId = _authProvider.user?.id;
                        if (userId != null) {
                          await skillProvider.toggleTeachSkill(userId, skill);
                        }
                      },
                      type: SkillTagType.teach,
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 32),
              Text(
                'What do you want to learn?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Consumer<SkillProvider>(builder: (context, skillProvider, child) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableSkills.map((skill) {
                    final isSelected =
                        skillProvider.selectedLearnSkills.contains(skill);
                    return SkillTag(
                      skill: skill,
                      isSelected: isSelected,
                      onTap: () async {
                        final userId = _authProvider.user?.id;
                        skillProvider.toggleLearnSkill(userId!, skill);
                      },
                      type: SkillTagType.learn,
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Complete Profile',
                isLoading: _skillProvider.isLoading,
                onPressed: () async {
                  validateSkill();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
