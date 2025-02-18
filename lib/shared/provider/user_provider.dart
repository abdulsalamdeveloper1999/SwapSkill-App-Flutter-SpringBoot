import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/auth/models/auth_response.dart';
import 'package:skill_swap_with_spring/features/auth/models/user_model.dart';
import 'package:skill_swap_with_spring/shared/provider/user_repo.dart';

class UserProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  User? _user;
  String? _token;

  UserProvider(this._prefs) {
    _loadUserFromPrefs();
  }

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;

  User? _currentUser;

  User get currentUser => _currentUser!;

  Future<User> getUserById() async {
    final UserRepo userRepo = UserRepo(_prefs);
    User user = await userRepo.getUserById(_user!.id!);
    _currentUser = user;

    return user;
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final userJson = _prefs.getString('user_data');

      _token = _prefs.getString('access_token');

      if (userJson != null) {
        _user = User.fromJson(jsonDecode(userJson));
        notifyListeners();
      }
    } catch (e) {
      log('Error loading user data: $e');
    }
  }

  void setUser(AuthResponse authResponse) {
    _user = authResponse.user;
    _token = authResponse.accessToken;

    // Save to SharedPreferences
    _prefs.setString('user_data', jsonEncode(_user?.toJson()));
    _prefs.setString('access_token', authResponse.accessToken ?? '');

    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _token = null;

    // Clear from SharedPreferences
    _prefs.remove('user_data');
    _prefs.remove('access_token');

    notifyListeners();
  }
}
