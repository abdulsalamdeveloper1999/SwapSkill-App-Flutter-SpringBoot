// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../auth/models/user_model.dart';

class SkillSwapRequestResponseDto {
  final String id;
  final User sender;
  final User receiver;
  final List<String> senderTeachSkills;
  final List<String> senderLearnSkills;
  final String message;
  final String status;
  final String createdAt;
  final String updatedAt;

  SkillSwapRequestResponseDto({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.senderTeachSkills,
    required this.senderLearnSkills,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SkillSwapRequestResponseDto.fromJson(Map<String, dynamic> json) {
    try {
      return SkillSwapRequestResponseDto(
        id: json["id"] ?? "",
        sender:
            User.fromJson(json["sender"] ?? {}), // Convert sender to User model
        receiver: User.fromJson(
            json["receiver"] ?? {}), // Convert receiver to User model
        senderTeachSkills: List<String>.from(json["senderTeachSkills"] ?? []),
        senderLearnSkills: List<String>.from(json["senderLearnSkills"] ?? []),
        message: json["message"] ?? "",
        status: json["status"] ?? "",
        createdAt: json["createAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
      );
    } catch (e) {
      rethrow;
    }
  }

  static List<SkillSwapRequestResponseDto> fromJsonList(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => SkillSwapRequestResponseDto.fromJson(json))
        .toList();
  }

  @override
  String toString() {
    return 'SkillSwapRequestResponseDto(id: $id, sender: $sender, receiver: $receiver, senderTeachSkills: $senderTeachSkills, senderLearnSkills: $senderLearnSkills, message: $message, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
