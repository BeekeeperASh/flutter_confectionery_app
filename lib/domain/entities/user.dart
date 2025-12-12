class User {
  final String id;
  final String name;
  final String? email;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    this.email,
    this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}