// services/chat_service.dart

import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatService {
  Future<List<Chat>> getChatRooms(String userId);

  Future<List<MessageDto>> getMessages(String chatRoomId);

  Future<Message> sendMessage(
      String chatRoomId, String senderId, String content);
}
