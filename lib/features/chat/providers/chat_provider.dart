import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/chat/models/chat_model.dart';
import 'package:skill_swap_with_spring/features/chat/repository/chat_repo.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo _chatRepo;
  // ignore: unused_field
  final SharedPreferences _prefs;

  ChatProvider(this._prefs) : _chatRepo = ChatRepo(_prefs);

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MessageDto> _messages = [];
  final StreamController<List<MessageDto>> _messagesController =
      StreamController.broadcast();
  // Expose messagesStream as a getter
  Stream<List<MessageDto>> get messagesStream => _messagesController.stream;
  // List to store chat messages
  // List<MessageDto> _messages = [];
  List<MessageDto> get messages => _messages;
  Future<void> getUserChats(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _chats = await _chatRepo.getChatRooms(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

// Fetch messages continuously using a stream
  void startMessageStream(String chatRoomId) {
    _isLoading = true;
    notifyListeners();

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final newMessages = await _chatRepo.getMessages(chatRoomId);
        _messages = newMessages;

        // Push new messages to the stream
        _messagesController.add(_messages);
      } catch (e) {
        _messagesController.addError("Failed to fetch messages");
      }
    });

    _isLoading = false;
    notifyListeners();
  }

  // // Fetch messages for a given chat room ID
  // Future<void> getMessages(String chatRoomId) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //     _messages = await _chatRepo.getMessages(chatRoomId);

  //     _isLoading = false;
  //     notifyListeners();
  //   } catch (e) {
  //     _isLoading = false;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }

  Future<void> sendMessage(
    String chatRoomId,
    String senderId,
    String content,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _chatRepo.sendMessage(chatRoomId, senderId, content);
      // await getMessages(chatRoomId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _messagesController.close();
    super.dispose();
  }
}
