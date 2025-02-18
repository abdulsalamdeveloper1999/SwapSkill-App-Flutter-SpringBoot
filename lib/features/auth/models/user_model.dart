// ignore_for_file: public_member_api_docs, sort_constructors_first

class User {
  final String? id; // UUID from backend
  final String username;
  final String email;
  final Set<String>? canTeach;
  final Set<String>? wantToLearn;

  User({
    this.id,
    required this.username,
    required this.email,
    this.canTeach,
    this.wantToLearn,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id']?.toString(), // Convert UUID to string
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        canTeach: (json['canTeach'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toSet() ??
            <String>{},
        wantToLearn: (json['wantToLearn'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toSet() ??
            <String>{},
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'canTeach': canTeach?.toList(),
        'wantToLearn': wantToLearn?.toList(),
      };

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, canTeach: $canTeach, wantToLearn: $wantToLearn)';
  }
}
