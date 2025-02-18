import 'dart:convert';

class SkillSwapRequestDto {
  final String senderId;
  final String receiverId;
  final List<String> senderTeachSkills;
  final List<String> senderLearnSkills;
  final String message;

  SkillSwapRequestDto({
    required this.senderId,
    required this.receiverId,
    required this.senderTeachSkills,
    required this.senderLearnSkills,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "senderTeachSkills": senderTeachSkills,
      "senderLearnSkills": senderLearnSkills,
      "message": message,
    };
  }

  String toRawJson() => json.encode(toJson());
}
