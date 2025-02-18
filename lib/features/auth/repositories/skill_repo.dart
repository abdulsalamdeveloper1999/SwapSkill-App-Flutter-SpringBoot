
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/auth/models/user_model.dart';
import 'package:skill_swap_with_spring/shared/exceptions/api_exception.dart';

class SkillRepository {
  final dio = Dio();
  final baseUrl = 'http://192.168.1.173:8080/api/users';
  final SharedPreferences _prefs;

  Future<User> addTeachingSkill(String userId, String skill) async {
    try {
      final response = await dio.post(
        '$baseUrl/$userId/skills/teach',
        data: skill,
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw APIException.fromDioError(e);
    } catch (e) {
      throw APIException(
        message: 'Failed to add teaching skill: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<void> addLearnSkill(String userId, String skill) async {
    try {
      final response = await dio.post(
        '$baseUrl/$userId/skills/learn',
        data: skill,
      );

      if (response.statusCode != 200) {
        throw APIException(
            message: 'Failed to add skill',
            statusCode: response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw APIException(
          message: 'Failed to add teaching skill: ${e.toString()}',
          statusCode: 500);
    } catch (e) {
      throw APIException(
        message: 'Failed to add teaching skill: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<void> removeTeachingSkill(String userId, String skill) async {
    try {
      final response = await dio.delete(
        '$baseUrl/$userId/skill/teach/$skill', // Match the path format
      );

      if (response.statusCode != 200) {
        throw APIException(
            message: "Failed to remove skill",
            statusCode: response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw APIException.fromDioError(e);
    } catch (e) {
      throw APIException(
        message: 'Failed to remove skill: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<void> removeLearnSkill(String userId, String skill) async {
    try {
      final response = await dio.delete('$baseUrl/$userId/skill/learn/$skill');
      if (response.statusCode != 200) {
        throw APIException(
            message: "Failed to remove skill",
            statusCode: response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw APIException.fromDioError(e);
    } catch (e) {
      throw APIException(
        message: 'Failed to remove skill: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<User> getSkills(String userId) async {
    try {
      final response = await dio.get('$baseUrl/$userId/skills');

      if (response.statusCode != 200) {
        throw APIException(
            message: "Failed to get skills",
            statusCode: response.statusCode ?? 500);
      }

      final user = User.fromJson(response.data);
      return user;

      // return Set<String>.from(user.canTeach ?? []);
    } on DioException catch (e) {
      throw APIException.fromDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  // Add JWT token to requests
  SkillRepository(this._prefs) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Get token from storage/provider
        final token = _prefs.getString('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['Content-Type'] = 'application/json';

        return handler.next(options);
      },
    ));
  }
}
