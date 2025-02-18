// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chat {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderUsername;
  final String reciverName;
  final List<MessageDto> messages;
  Chat({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderUsername,
    required this.reciverName,
    required this.messages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderUsername': senderUsername,
      'reciverName': reciverName,
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] ?? "",
      senderId: map['senderId'] ?? "",
      receiverId: map['receiverId'] ?? "",
      senderUsername: map['senderUsername'] ?? "",
      reciverName: map['reciverName'] ?? "",
      messages: List<MessageDto>.from(
        (map['messages'] as List<dynamic>?)?.map<MessageDto>(
                (x) => MessageDto.fromMap(x as Map<String, dynamic>)) ??
            [], // Default to an empty list if messages is null
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MessageDto {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;

  MessageDto({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory MessageDto.fromMap(Map<String, dynamic> map) {
    return MessageDto(
      id: map['id'] as String? ??
          '', // Provide a fallback value for nullable String
      senderId: map['senderId'] as String? ??
          '', // Provide a fallback value for nullable String
      content: map['content'] as String? ??
          '', // Provide a fallback value for nullable String
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ??
          DateTime.now(), // Parse string to DateTime
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageDto.fromJson(String source) =>
      MessageDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
