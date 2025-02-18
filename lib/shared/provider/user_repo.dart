import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/shared/exceptions/api_exception.dart';

import '../../features/auth/models/user_model.dart';

class UserRepo {
  final SharedPreferences _prefs;
  String tokenKey = 'access_token';
  UserRepo(this._prefs) {
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

  final dio = Dio()
    ..options = BaseOptions(
      validateStatus: (status) => status! < 500,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  final baseUrl = 'http://192.168.1.173:8080/api/auth';

  Future<User> getUserById(String userId) async {
    try {
      final response = await dio.get('$baseUrl/id/$userId');

      if (response.statusCode != 200) {
        throw APIException(
            message: "User not found", statusCode: response.statusCode ?? 500);
      }
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw APIException.fromDioError(e);
    } catch (e) {
      throw APIException(
          message: "User not found: ${e.toString()}", statusCode: 500);
    }
  }
}


//  @GetMapping("/{username}")
//     public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
//         User user = userService.findByUsername(username);
//         if (user != null) {
//             return ResponseEntity.ok(user);
//         }
//         throw new ApiException("User not found", HttpStatus.NOT_FOUND);
//     }