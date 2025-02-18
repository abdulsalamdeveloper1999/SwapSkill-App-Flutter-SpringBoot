import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/chat/models/chat_model.dart';
import 'package:skill_swap_with_spring/features/chat/models/message_model.dart';
import 'package:skill_swap_with_spring/features/chat/repository/chat_service.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRepo implements ChatService {
  final dio = Dio()
    ..options = BaseOptions(
      validateStatus: (status) => status! < 500,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  final baseUrl = 'http://192.168.1.173:8080/api/chat';
  // WebSocket channel
  // ignore: unused_field
  late WebSocketChannel _webSocketChannel;
  final String tokenKey = "access_token";

  final SharedPreferences _prefs;

  ChatRepo(this._prefs) {
    _webSocketChannel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.173:8080/ws'),
    );

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

  @override
  Future<List<Chat>> getChatRooms(String userId) async {
    try {
      final response = await dio.get('$baseUrl/$userId');

      return (response.data as List).map((chat) => Chat.fromMap(chat)).toList();
    } catch (e) {
      throw Exception("Failed to fetch chat rooms $e");
    }
  }

  @override
  Future<List<MessageDto>> getMessages(String chatRoomId) async {
    try {
      final response = await dio.get('$baseUrl/$chatRoomId/messages');

      if (response.data is List) {
        return (response.data as List)
            .map((msg) => MessageDto.fromMap(msg))
            .toList();
      } else {
        throw Exception("Unexpected response format: ${response.data}");
      }
    } catch (e) {
      throw Exception("Failed to fetch messages");
    }
  }

  @override
  Future<Message> sendMessage(
      String chatRoomId, String senderId, String content) async {
    try {
      final response = await dio.post(
        '$baseUrl/$chatRoomId/send',
        queryParameters: {'senderId': senderId},
        data: content,
      );
      return Message.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to send message");
    }
  }
}
