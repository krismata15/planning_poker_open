class GameEntity {
  GameEntity({
    this.id,
    this.name,
  });

  GameEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
  GameEntity copyWith({
    String? id,
    String? name,
  }) =>
      GameEntity(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
