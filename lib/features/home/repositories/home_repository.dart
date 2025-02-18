import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/auth/models/user_model.dart';
import 'package:skill_swap_with_spring/shared/exceptions/api_exception.dart';

import '../../../shared/provider/user_provider.dart';

class HomeRepository {
  final SharedPreferences _prefs;

  Dio dio = Dio()
    ..options = BaseOptions(
      validateStatus: (status) {
        return status! < 500;
      },
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

  final baseUrl = 'http://192.168.1.173:8080/api/auth';

  final String tokenKey = "access_token";
  HomeRepository(this._prefs) {
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
  Future<List<User>> getAllUsers(BuildContext context) async {
    try {
      final response = await dio.get(
        '$baseUrl/getAllUsers',
      );

      if (response.statusCode != 200) {
        throw APIException(
            message: "Users not found", statusCode: response.statusCode ?? 500);
      }
      // Get current user from provider or storage

      final currentUser = context.read<UserProvider>().user!.id;
      return (response.data as List)
          .map((userData) => User.fromJson(userData))
          .where((user) => user.id != currentUser)
          .toList();
    } on DioException catch (e) {
      throw APIException(message: "Error : $e", statusCode: 500);
    } catch (e) {
      throw APIException(message: "Error : $e", statusCode: 500);
    }
  }
}
