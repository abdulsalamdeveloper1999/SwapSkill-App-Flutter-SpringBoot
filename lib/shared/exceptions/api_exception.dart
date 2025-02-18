// exceptions/api_exception.dart
import 'package:dio/dio.dart';

class APIException implements Exception {
  final String message;
  final int statusCode;

  APIException({
    required this.message,
    required this.statusCode,
  });

  factory APIException.fromDioError(DioException e) {
    if (e.response != null) {
      // Make sure to parse statusCode as int and message as String
      return APIException(
        message:
            e.response?.data['message']?.toString() ?? 'Something went wrong',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
    return APIException(
      message: 'Network error occurred',
      statusCode: 500,
    );
  }

  @override
  String toString() => message;
}
