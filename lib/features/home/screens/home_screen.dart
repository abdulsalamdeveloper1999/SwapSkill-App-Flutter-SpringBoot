// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:skill_swap_with_spring/features/home/providers/home_provider.dart';
import 'package:skill_swap_with_spring/features/profile/screens/profile_screen.dart';
import 'package:skill_swap_with_spring/features/request_skill/screens/request_managament_screen.dart';
import 'package:skill_swap_with_spring/shared/provider/user_provider.dart';
import 'package:skill_swap_with_spring/shared/widgets/navigator.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../chat/screens/chat_list_screen.dart';
import '../widgets/match_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // Use WidgetsBinding to defer the method call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use read method to avoid listening
      context.read<HomeProvider>().getAllUsers(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: const GradientText('SkillSwap', fontSize: 28),
              actions: [
                IconButton(
                    icon: const Icon(LucideIcons.plus),
                    onPressed: () {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (_) => RequestsScreen()));
                      // },
                      navigator(context, RequestsManagementScreen());
                    }),

                IconButton(
                  icon: const Icon(LucideIcons.messageCircle), // Chat icon
                  onPressed: () => navigator(context, ChatListScreen()),
                ),
                // IconButton(
                //   icon: const Icon(LucideIcons.logOut),
                //   onPressed: () {
                //     context.read<UserProvider>().clearUser();
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (_) => LoginScreen()));
                //   },
                // ),
                IconButton(
                  icon: const Icon(LucideIcons.personStanding),
                  onPressed: () async {
                    final user =
                        await context.read<UserProvider>().getUserById();

                    // Check if the widget is still in the tree
                    if (!context.mounted) return;

                    navigator(
                        context,
                        ProfileScreen(
                          userData: user,
                        ));
                  },
                ),
              ],
            ),
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBar(
                  leading: const Icon(LucideIcons.search),
                  hintText: 'Search for skills or people...',
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).cardColor,
                  ),
                ),
              ),
            ),
            // Categories
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _CategoryChip(
                      icon: LucideIcons.code2,
                      label: 'Programming',
                      onTap: () {},
                    ),
                    _CategoryChip(
                      icon: LucideIcons.palette,
                      label: 'Design',
                      onTap: () {},
                    ),
                    _CategoryChip(
                      icon: LucideIcons.languages,
                      label: 'Languages',
                      onTap: () {},
                    ),
                    _CategoryChip(
                      icon: LucideIcons.music,
                      label: 'Music',
                      onTap: () {},
                    ),
                    _CategoryChip(
                      icon: LucideIcons.camera,
                      label: 'Photography',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Perfect Matches',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Match Cards Grid
            Consumer<HomeProvider>(builder: (context, homeProvider, child) {
              return homeProvider.isLoading
                  ? SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SliverList.builder(
                      itemCount: homeProvider.usersData.length, // Sample count
                      itemBuilder: (context, index) {
                        final user = homeProvider.usersData[index];
                        return Container(
                          margin: const EdgeInsets.all(16),

                          child: MatchCard(
                            user: user,
                          ), // Replace with your widget
                        );
                      },
                    );
            }),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            spacing: 10,
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.white,
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
