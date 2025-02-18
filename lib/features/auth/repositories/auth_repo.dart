import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/auth/models/user_model.dart';

import '../../../shared/exceptions/api_exception.dart';
import '../models/auth_response.dart';
import '../models/registeration_dto.dart';

class AuthRepository {
  final dio = Dio()
    ..options = BaseOptions(
      validateStatus: (status) => status! < 500,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  final baseUrl = 'http://192.168.1.173:8080/api/auth';

  final String tokenKey = "access_token";

  final SharedPreferences _prefs;

  AuthRepository(this._prefs) {
    //Add token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _prefs.getString(tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<AuthResponse> register(RegistrationDto dto) async {
    try {
      final response = await dio.post(
        '$baseUrl/register',
        data: dto.toJson(),
      );

      // Parse string response to JSON if needed
      final responseData =
          response.data is String ? jsonDecode(response.data) : response.data;

      return AuthResponse.fromJson(responseData);
    } on DioException catch (e) {
      throw APIException.fromDioError(e);
    } catch (e) {
      throw APIException(
        message: 'Failed to parse response: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<AuthResponse> login(LoginDto dto) async {
    try {
      final response = await dio.post(
        '$baseUrl/login',
        data: dto.toJson(),
      );

      dynamic responseData = response.data;
      if (responseData is String) {
        // Trim the response to catch empty or whitespace-only responses.
        if (responseData.trim().isEmpty) {
          throw APIException(
            message: 'Empty response received from server.',
            statusCode: response.statusCode ?? 500,
          );
        }
        // Attempt to decode the response string
        responseData = json.decode(responseData);
      }

      // Ensure responseData is a Map
      if (responseData is! Map<String, dynamic>) {
        throw APIException(
          message: 'Invalid response format',
          statusCode: 500,
        );
      }
      return AuthResponse.fromJson(responseData);
    } on DioException catch (e) {
      log(e.toString());
      throw APIException.fromDioError(e);
    } catch (e) {
      throw APIException(
        message: 'Login failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<User?> validateToken() async {
    try {
      final token = _prefs.getString(tokenKey);
      if (token != null) {
        return null;
      }

      final response = await dio.get('$baseUrl/me');

      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _prefs.remove(tokenKey);
        await _prefs.remove("refresh_token");
      }
      return null;
    }
  }
}
