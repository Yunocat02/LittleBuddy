// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class usermodel {
  final String username;
  final String role;
  usermodel({
    required this.username,
    required this.role,
  });
  

  usermodel copyWith({
    String? username,
    String? role,
  }) {
    return usermodel(
      username: username ?? this.username,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'role': role,
    };
  }

  factory usermodel.fromMap(Map<String, dynamic> map) {
    return usermodel(
      username: map['username'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory usermodel.fromJson(String source) => usermodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'usermodel(username: $username, role: $role)';

  @override
  bool operator ==(covariant usermodel other) {
    if (identical(this, other)) return true;
  
    return 
      other.username == username &&
      other.role == role;
  }

  @override
  int get hashCode => username.hashCode ^ role.hashCode;
}
