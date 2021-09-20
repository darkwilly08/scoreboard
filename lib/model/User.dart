class User {
  int? id;
  String name;
  String initial;
  bool favorite;

  User(
      {this.id,
      required this.name,
      required this.initial,
      required bool this.favorite});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'initial': initial,
      'favorite': favorite ? 1 : 0,
    };
  }
}
