import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth_usecases.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthViewModel(
      this._loginUseCase,
      this._logoutUseCase,
      this._getCurrentUserUseCase,
      ) : super(AuthInitial()) {
    initialize();
  }

  Future<void> initialize() async {
    state = AuthLoading();
    try {
      final userName = await _getCurrentUserUseCase.execute();
      final user = User(id: 'current_user', name: userName.name);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError('Ошибка загрузки пользователя: $e');
    }
  }

  Future<void> loadCurrentUser() async {
    state = AuthLoading();
    try {
      final userName = await _getCurrentUserUseCase.execute();
      final user = User(id: 'current_user', name: userName.name);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError('Ошибка загрузки пользователя: $e');
    }
  }

  Future<void> login(String name) async {
    state = AuthLoading();
    try {
      final userName = await _loginUseCase.execute(name);
      final user = User(id: DateTime.now().microsecondsSinceEpoch.toString(), name: userName.name);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthLoading();
    try {
      await _logoutUseCase.execute();
      state = AuthUnauthenticated();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> updateUserName(String newName) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      final updatedUser = currentState.user.copyWith(name: newName);
      state = AuthAuthenticated(updatedUser);
    }
  }
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}