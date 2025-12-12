import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String name;
  final String? email;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.createdAt,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt,
    );
  }
}