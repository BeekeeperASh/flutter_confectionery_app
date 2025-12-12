import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> execute(String name) async {
    final user = User(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
    );
    await _repository.login(user);
    return user;
  }
}

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> execute() async {
    await _repository.logout();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<User> execute() async {
    return await _repository.getCurrentUser();
  }
}

class UpdateUserUseCase {
  final AuthRepository _repository;

  UpdateUserUseCase(this._repository);

  Future<User> execute(User user) async {
    return await _repository.updateUser(user);
  }

  Future<User> executeAlt(String name) async {
    final currentUser = await _repository.getCurrentUser();
    final updatedUser = currentUser.copyWith(name: name);
    return await _repository.updateUser(updatedUser);
  }
}
