import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<User> login(User user) async {
    await _localDataSource.saveUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearUser();
  }

  @override
  Future<User> getCurrentUser() async {
    return await _localDataSource.getUser();
  }

  @override
  Future<User> updateUser(User user) async {
    await _localDataSource.saveUser(user);
    return user;
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await _localDataSource.getUser();
    return user.id != 'guest';
  }
}