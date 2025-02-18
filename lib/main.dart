import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/auth/screens/complete_profile.dart';
import 'package:skill_swap_with_spring/features/chat/providers/chat_provider.dart';
import 'package:skill_swap_with_spring/features/home/providers/home_provider.dart';
import 'package:skill_swap_with_spring/features/request_skill/providers/skill_swap_provider.dart';
import 'package:skill_swap_with_spring/shared/provider/user_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/providers/skill_provider.dart';
import 'features/auth/repositories/skill_repo.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userProvider = UserProvider(prefs); // Create instance first

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: userProvider, // Provide the instance
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(prefs, userProvider),
        ),
        ChangeNotifierProvider(
          create: (_) => SkillProvider(SkillRepository(prefs)),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => SkillSwapProvider(userProvider, prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(prefs),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SkillSwap',
          theme: AppTheme.darkTheme,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (!authProvider.isAuthenticated) {
                return const LoginScreen();
              }

              return Builder(
                builder: (context) {
                  _checkUserSkills(context);
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            },
          )),
    );
  }

// Add this method to your widget or state class
  Future<void> _checkUserSkills(BuildContext context) async {
    try {
      final user = await context.read<UserProvider>().getUserById();

      final hasSkills = (user.canTeach?.isNotEmpty == true) ||
          (user.wantToLearn?.isNotEmpty == true);
      if (!context.mounted) return;
      if (!hasSkills) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => CompleteProfileScreen(
                  fromLogin: true,
                )));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    } catch (e) {
      if (!context.mounted) return;
      // Handle any errors during user retrieval
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }
}
