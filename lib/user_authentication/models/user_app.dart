import 'package:equatable/equatable.dart';

class UserApp extends Equatable {
  const UserApp({
    required this.id,
    required this.username,
    required this.type,
    required this.createdAt,
  });

  UserApp.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        type = json['type'],
        createdAt = json['createdAt'].toString();

  final String id;
  final String username;
  final String type;
  final String createdAt;
  UserApp copyWith({
    String? id,
    String? username,
    String? type,
    String? createdAt,
  }) =>
      UserApp(
        id: id ?? this.id,
        username: username ?? this.username,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['type'] = type;
    map['createdAt'] = createdAt;
    return map;
  }

  @override
  List<Object?> get props => [id, username, type];
}
