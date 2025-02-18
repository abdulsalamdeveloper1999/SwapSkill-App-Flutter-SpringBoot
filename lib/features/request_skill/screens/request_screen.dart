import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap_with_spring/features/auth/models/user_model.dart';
import 'package:skill_swap_with_spring/features/request_skill/providers/skill_swap_provider.dart';
import 'package:skill_swap_with_spring/shared/provider/user_provider.dart';
import 'package:skill_swap_with_spring/shared/widgets/custom_button.dart';
import 'package:skill_swap_with_spring/shared/widgets/snackBar.dart';

import '../../../core/theme/app_theme.dart';
import '../models/skill_swap_request_dto.dart';

class SkillSwapRequestScreen extends StatefulWidget {
  final User targetUser;
  final User currentUser;

  const SkillSwapRequestScreen(
      {super.key, required this.targetUser, required this.currentUser});

  @override
  State<SkillSwapRequestScreen> createState() => _SkillSwapRequestScreenState();
}

class _SkillSwapRequestScreenState extends State<SkillSwapRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // My skills to teach
  List<String> _myTeachSkills = [];

  // Skills I want to learn from the target user
  List<String> _targetLearnSkills = [];

  // Selected skills
  List<String> _selectedTeachSkills = [];
  List<String> _selectedLearnSkills = [];

  final TextEditingController message = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Use current user's teachable skills
    _myTeachSkills = List<String>.from(widget.currentUser.canTeach ?? []);

    // Use target user's learnable skills
    _targetLearnSkills = List<String>.from(widget.targetUser.wantToLearn ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skill Swap Request to ${widget.targetUser.username}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Preview
                _buildUserProfileHeader(),

                const SizedBox(height: 24),

                // Skills to Teach Selection
                _buildMultiSelectSection(
                  title: 'Skills I Can Teach',
                  allSkills: _myTeachSkills,
                  selectedSkills: _selectedTeachSkills,
                  onSelectionChanged: (skills) {
                    setState(() {
                      _selectedTeachSkills = skills;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Skills to Learn Selection
                _buildMultiSelectSection(
                  title: 'Skills I Want to Learn',
                  allSkills: _targetLearnSkills,
                  selectedSkills: _selectedLearnSkills,
                  onSelectionChanged: (skills) {
                    setState(() {
                      _selectedLearnSkills = skills;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Request Message
                TextFormField(
                  controller: message,
                  decoration: InputDecoration(
                    labelText: 'Request Message',
                    hintText: 'Explain your skill swap goals...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 4,
                  minLines: 1,
                ),

                const SizedBox(height: 24),

                Center(
                  child: Consumer<SkillSwapProvider>(
                      builder: (context, provider, child) {
                    return CustomButton(
                      isLoading: provider.isLoading,
                      text: 'Send Skill Swap Request',
                      onPressed: _submitRequest,
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                widget.targetUser.username.substring(0, 1).toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.targetUser.username,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 20,
                        ),
                  ),
                  Text(
                    'Wants to learn: ${widget.targetUser.wantToLearn?.join(", ") ?? "No skills listed"}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectSection({
    required String title,
    required List<String> allSkills,
    required List<String> selectedSkills,
    required Function(List<String>) onSelectionChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 20,
              ),
        ),
        const SizedBox(height: 16),
        allSkills.isEmpty
            ? Text(
                'No skills available',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allSkills.map((skill) {
                  final isSelected = selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (bool value) {
                      List<String> updatedSkills = List.from(selectedSkills);
                      if (value) {
                        updatedSkills.add(skill);
                      } else {
                        updatedSkills.remove(skill);
                      }
                      onSelectionChanged(updatedSkills);
                    },
                    selectedColor: AppTheme.primaryBlue.withAlpha(50),
                    checkmarkColor: AppTheme.primaryBlue,
                  );
                }).toList(),
              ),
        if (selectedSkills.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Selected: ${selectedSkills.join(", ")}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  void _submitRequest() {
    if (_selectedTeachSkills.isEmpty || _selectedLearnSkills.isEmpty) {
      showSnackBar(
        context,
        'Please select skills to teach and learn',
        AppTheme.primaryBlue,
      );
      return;
    }
    SkillSwapRequestDto request = SkillSwapRequestDto(
      senderId: context.read<UserProvider>().currentUser.id!,
      receiverId: widget.targetUser.id!,
      senderTeachSkills: _selectedTeachSkills,
      senderLearnSkills: _selectedLearnSkills,
      message: message.text,
    );
    context.read<SkillSwapProvider>().createRequest(request);

    showSnackBar(
      context,
      'Skill Swap Request sent to ${widget.targetUser.username}!',
      AppTheme.primaryBlue,
    );
  }
}
