// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/auth/models/user_model.dart';
import 'package:skill_swap_with_spring/features/home/repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final HomeRepository _homeRepository;

  HomeProvider(this._prefs) : _homeRepository = HomeRepository(_prefs);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // Error state
  String? _error;
  String? get error => _error;

  List<User> _usersData = [];
  List<User> get usersData => _usersData;
  Future<void> getAllUsers(BuildContext context) async {
    // Reset error
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch users from repository

      _usersData = await _homeRepository.getAllUsers(context);

      // Clear any previous errors
      _error = null;
      _isLoading = true;
      notifyListeners();
    } catch (e) {
      // Set error state
      _error = e.toString();
      _usersData = []; // Ensure users list is cleared on error
    } finally {
      // Always set loading to false
      _isLoading = false;
      notifyListeners();
    }
  }
}
