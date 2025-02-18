import 'user_model.dart';

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final User user;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    try {
      return AuthResponse(
        accessToken: json['token'] as String?,
        refreshToken: json['refreshToken'] as String?,
        // Safely extract user data
        user: User.fromJson(json['user'] ??
            json), // Try json['user'] first, fallback to entire json
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'user': user.toJson(),
      };
}
