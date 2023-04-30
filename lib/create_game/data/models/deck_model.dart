import 'package:equatable/equatable.dart';

/// id : "23213213123"
/// name : "fibo fibo"
/// options : ["1","3","5"]
/// type : "standard"
/// user_id : null

class DeckModel extends Equatable {
  DeckModel({
    this.id,
    this.name,
    this.options,
    this.type,
    this.userId,
  });

  DeckModel.fromJsonFirebase(Map<String, dynamic> json, String uid) {
    print('entrando aqui $uid');
    print('entrando aqui ${json['name']}');
    id = uid;
    name = json['name'];
    options =
        json['options'] != null ? (json['options'] as List).cast<String>() : [];
    type = json['type'];
    userId = json['user_id'];
  }

  DeckModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    options =
        json['options'] != null ? (json['options'] as List).cast<String>() : [];
    type = json['type'];
    userId = json['user_id'];
  }

  String? id;
  String? name;
  List<String>? options;
  String? type;
  dynamic userId;

  DeckModel copyWith({
    String? id,
    String? name,
    List<String>? options,
    String? type,
    dynamic userId,
  }) =>
      DeckModel(
        id: id ?? this.id,
        name: name ?? this.name,
        options: options ?? this.options,
        type: type ?? this.type,
        userId: userId ?? this.userId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['options'] = options;
    map['type'] = type;
    map['user_id'] = userId;
    return map;
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'DeckModel{id: $id, name: $name, options: $options, type: $type, userId: $userId}';
  }
}
