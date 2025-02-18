import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserDro {
  final String userId;
  final String username;
  final Set<String> canTeach;
  final Set<String> wantToLearn;
  UserDro({
    required this.userId,
    required this.username,
    required this.canTeach,
    required this.wantToLearn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'username': username,
      'canTeach': canTeach.toList(),
      'wantToLearn': wantToLearn.toList(),
    };
  }

  factory UserDro.fromMap(Map<String, dynamic> map) {
    return UserDro(
      userId: map['userId'] as String,
      username: map['username'] as String,
      canTeach: Set<String>.from((map['canTeach'] as Set<String>)),
      wantToLearn: Set<String>.from((map['wantToLearn'] as Set<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDro.fromJson(String source) =>
      UserDro.fromMap(json.decode(source) as Map<String, dynamic>);
}
