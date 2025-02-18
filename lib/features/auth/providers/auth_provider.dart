// providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/shared/provider/user_provider.dart';

import '../models/auth_response.dart';
import '../models/registeration_dto.dart';
import '../models/user_model.dart';
import '../repositories/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SharedPreferences _prefs;
  final UserProvider _userProvider;

  AuthProvider(this._prefs, this._userProvider)
      : _authRepository = AuthRepository(_prefs) {
    _loadAuthState();
  } // Constructor injection
  AuthResponse? _authResponse;
  bool _isLoading = false;
  String? _error;

  // Getters
  AuthResponse? get authResponse => _authResponse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  User? get user => _authResponse?.user;

  void _loadAuthState() {
    final token = _prefs.getString('access_token');
    final refreshToken = _prefs.getString('refresh_token');
    final user = _userProvider.user;

    if (token != null && user != null) {
      _authResponse = AuthResponse(
        accessToken: token,
        refreshToken: refreshToken,
        user: user,
      );
      notifyListeners();
    }
  }

  bool get isAuthenticated {
    final token = _prefs.getString('access_token');
    return token != null && _userProvider.user != null;
  }

  Future<void> login(LoginDto dto) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final authResponse = await _authRepository.login(dto);

      _authResponse = authResponse;

      // // Save tokens
      // await _prefs.setString('access_token', authResponse.accessToken!);
      // await _prefs.setString('refresh_token', authResponse.refreshToken!);

      // Update user state
      _userProvider.setUser(authResponse);

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

  Future<void> register({required RegistrationDto dto}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final authResponse = await _authRepository.register(dto);

      _authResponse = authResponse;

      // // Save tokens
      // await _prefs.setString('access_token', authResponse.accessToken!);
      // await _prefs.setString('refresh_token', authResponse.refreshToken!);

      // Update user state
      _userProvider.setUser(authResponse);

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

// Add method to get token
  String? getAccessToken() {
    return _prefs.getString('access_token');
  }

  // Add logout method to clear tokens
  Future<void> logout() async {
    await _prefs.remove('access_token');
    await _prefs.remove('refresh_token');
    _authResponse = null;
    notifyListeners();
  }
}
