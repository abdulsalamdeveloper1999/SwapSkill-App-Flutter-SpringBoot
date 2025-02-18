import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap_with_spring/features/auth/models/user_model.dart';
import 'package:skill_swap_with_spring/features/auth/providers/auth_provider.dart';
import 'package:skill_swap_with_spring/features/auth/screens/complete_profile.dart';
import 'package:skill_swap_with_spring/features/auth/screens/login_screen.dart';
import 'package:skill_swap_with_spring/shared/widgets/navigator.dart';

import '../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final User userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              navigator(context, LoginScreen());
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.cardDark,
                    child: Text(
                      userData.username.substring(0, 1).toUpperCase(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData.username,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    userData.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Skills Section
            _buildSkillSection(
              context,
              title: 'Skills I Can Teach',
              skills: List<String>.from(userData.canTeach ?? []),
              isTeachSkill: true,
            ),
            const SizedBox(height: 24),
            _buildSkillSection(
              context,
              title: 'Skills I Want to Learn',
              skills: List<String>.from(userData.wantToLearn ?? []),
              isTeachSkill: false,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigator(
              context,
              CompleteProfileScreen(
                fromLogin: false,
              ));
          // Edit Profile functionality
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.edit, color: AppTheme.textPrimary),
      ),
    );
  }

  Widget _buildSkillSection(
    BuildContext context, {
    required String title,
    required List<String> skills,
    required bool isTeachSkill,
  }) {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              skills.isEmpty
                  ? Text(
                      'No skills added yet',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isTeachSkill
                                ? AppTheme.teachTagBg
                                : AppTheme.learnTagBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              color: isTeachSkill
                                  ? AppTheme.teachTagText
                                  : AppTheme.learnTagText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
