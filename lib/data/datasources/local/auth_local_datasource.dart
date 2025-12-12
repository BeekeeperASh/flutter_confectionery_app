import '../../../domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(User user);
  Future<User> getUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  User? _currentUser;

  @override
  Future<void> saveUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = user;
  }

  @override
  Future<User> getUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser ?? User(id: 'guest', name: 'Гость');
  }

  @override
  Future<void> clearUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = null;
  }
}