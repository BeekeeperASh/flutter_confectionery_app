import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(User user);
  Future<void> logout();
  Future<User> getCurrentUser();
  Future<User> updateUser(User user);
  Future<bool> isAuthenticated();
}