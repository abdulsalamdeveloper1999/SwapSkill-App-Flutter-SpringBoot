import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/request_skill/models/request_enum.dart';
import 'package:skill_swap_with_spring/features/request_skill/models/skill_swap_request_dto.dart';
import 'package:skill_swap_with_spring/features/request_skill/models/skill_swap_request_response_dto.dart';
import 'package:skill_swap_with_spring/features/request_skill/repository/skill_swap_service.dart';
import 'package:skill_swap_with_spring/shared/exceptions/api_exception.dart';

import '../../auth/models/user_model.dart';

class SkillReqRepository implements SkillSwapService {
  final dio = Dio()
    ..options =
        BaseOptions(validateStatus: (status) => status! < 500, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

  static const String baseUrl =
      'http://192.168.1.173:8080/api/skill-swap-requests';

  final String tokenKey = "access_token";

  final SharedPreferences _prefs;

  SkillReqRepository(this._prefs) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _prefs.getString(tokenKey);
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );

    // dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  @override
  Future<SkillSwapRequestResponseDto> createRequest(
      SkillSwapRequestDto request) async {
    final response =
        await dio.post('$baseUrl/create-request', data: request.toJson());
    if (response.statusCode != 300) {
      throw APIException(
        message: 'Could not create request',
        statusCode: response.statusCode ?? 500,
      );
    }

    return SkillSwapRequestResponseDto.fromJson(jsonDecode(response.data));
  }

  @override
  Future<List<SkillSwapRequestResponseDto>> getSentRequests(
      String userId) async {
    final response = await dio.get("$baseUrl/sent/$userId");

    if (response.statusCode != 200 || response.data == null) {
      throw APIException(
        message: 'Response is null',
        statusCode: response.statusCode ?? 500,
      );
    }
    // Ensure response.data is a list before passing it
    if (response.data is! List) {
      throw APIException(
        message: 'Invalid response format',
        statusCode: response.statusCode ?? 500,
      );
    }

    final data = (response.data as List)
        .map((json) => SkillSwapRequestResponseDto.fromJson(json))
        .toList();

    return data;
  }

  @override
  Future<List<SkillSwapRequestResponseDto>> getIncomingRequests(
      String userId) async {
    final response = await dio.get("$baseUrl/receiver/$userId");
    if (response.statusCode != 200) {
      throw APIException(
        message: 'Could not get incoming requests',
        statusCode: response.statusCode ?? 500,
      );
    }

    return SkillSwapRequestResponseDto.fromJsonList(response.data);
  }

  @override
  Future<Response> updateRequestStatus(
      String requestId, RequestStatus status) async {
    try {
      // Log the token for debugging
      // ignore: unused_local_variable
      final token = _prefs.getString(tokenKey);

      // Encode the status parameter
      final encodedStatus = Uri.encodeComponent(status.toApiString());
      final requestUrl = '$baseUrl/$requestId/status?status=$encodedStatus';

      // Make the PATCH request
      final response = await dio.patch(requestUrl);

      // Check for success status codes (200-299)
      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw APIException(
          message: 'Could not update status',
          statusCode: response.statusCode ?? 500,
        );
      }

      return response;
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive timeout';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Send timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Connection error: Check your network or server URL';
      } else if (e.response != null) {
        errorMessage = 'Server error: ${e.response?.statusCode}';
      }

      throw APIException(
          message: errorMessage, statusCode: e.response?.statusCode ?? 500);
    } catch (e) {
      // Throw a generic APIException
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }

  Future<double> findMatch(String userId, User otherUser) async {
    try {
      final response = await dio.post(
        "$baseUrl/find?userId=$userId",
        data: otherUser.toJson(),
      );

      // Check for success status codes (200-299)
      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw APIException(
          message: 'Could not get score',
          statusCode: response.statusCode ?? 500,
        );
      }

      return response.data;
    } on DioException catch (e) {
      throw APIException.fromDioError(e);
    } catch (e) {
      // Throw a generic APIException
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }

  // @PostMapping("/find")
  //   public List<UserMatchDTO> findMatches(

  //           @RequestParam("userId") UUID userId,
  //           @RequestBody List<User> allUsers) {

  //       User currecntUser = allUsers.stream().filter(user -> user.getId().equals(userId)).findFirst()
  //               .orElseThrow(() -> new IllegalArgumentException("User with ID " + userId + " not found"));

  //       return skillService.findMatches(currecntUser, allUsers);
  //   }
}
