// models/message.dart

class Message {
  final String? id;
  final String? senderId;
  final String text;
  final DateTime timestamp;

  // Constructor with nullable fields and required fields
  Message({
    this.id,
    this.senderId,
    required this.text,
    required this.timestamp,
  });

  // Factory method to create a Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String?,
      senderId: json['senderId'] as String?,
      text: json['text'] ?? '', // Handle null text
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ??
          DateTime.now(), // Handle null timestamp
    );
  }

  // Method to convert the Message to a map for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}


    // private UUID id;
    // private UUID senderId;
    // private String content;
    // private LocalDateTime timestamp;