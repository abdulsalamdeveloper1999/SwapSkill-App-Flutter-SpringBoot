// ignore_for_file: public_member_api_docs, sort_constructors_first
// lib/features/home/widgets/match_card.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap_with_spring/features/request_skill/providers/skill_swap_provider.dart';
import 'package:skill_swap_with_spring/shared/provider/user_provider.dart';

import 'package:skill_swap_with_spring/shared/widgets/navigator.dart';

import '../../../shared/widgets/skill_tag.dart';
import '../../auth/models/user_model.dart';
import '../../request_skill/screens/request_screen.dart';

class MatchCard extends StatefulWidget {
  final User user;
  const MatchCard({
    super.key,
    required this.user,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  @override
  void initState() {
    super.initState();
    // Trigger logic here
    context.read<SkillSwapProvider>().findMatch(
          context.read<UserProvider>().currentUser.id!,
          widget.user,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // User Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://api.dicebear.com/7.x/avataaars/png?seed=Felix',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            // const SizedBox(width: 4),
                            // Text(
                            //   '4.8',
                            //   style: Theme.of(context).textTheme.bodySmall,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Consumer<SkillSwapProvider>(
                      builder: (context, provider, child) {
                    // provider.findMatch(
                    //     context.read<UserProvider>().currentUser.id!,
                    //     widget.user);
                    return Text(
                      '${provider.score.toInt()}%',
                      style: TextStyle(
                        color: Colors.green[300],
                        fontSize: 12,
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Skills Section
            const Text(
              'Can Teach:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
                spacing: 4,
                runSpacing: 4,
                children: widget.user.canTeach!
                    .map(
                      (teach) => SkillTag(
                        skill: teach,
                        isSelected: true,
                        onTap: () {},
                        type: SkillTagType.teach,
                      ),
                    )
                    .toList()),
            const SizedBox(height: 12),
            const Text(
              'Wants to Learn:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            Wrap(
                spacing: 4,
                runSpacing: 4,
                children: widget.user.wantToLearn!
                    .map(
                      (learn) => SkillTag(
                        skill: learn,
                        isSelected: true,
                        onTap: () {},
                        type: SkillTagType.learn,
                      ),
                    )
                    .toList()),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(LucideIcons.view, size: 18),
                label: const Text('View'),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => const ChatScreen(username: 'Sarah Chen'),
                  //   ),
                  // );

                  navigator(
                    context,
                    SkillSwapRequestScreen(
                      targetUser: widget.user,
                      currentUser: context.read<UserProvider>().currentUser,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
