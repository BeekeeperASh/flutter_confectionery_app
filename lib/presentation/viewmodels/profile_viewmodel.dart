import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/auth_usecases.dart';

class ProfileViewModel extends StateNotifier<ProfileState> {
  final UpdateUserUseCase _updateUserUseCase;

  ProfileViewModel(this._updateUserUseCase) : super(ProfileInitial());

  Future<void> updateProfile(String name) async {
    state = ProfileLoading();
    try {
      await _updateUserUseCase.executeAlt(name);
      state = ProfileUpdated(name);
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }
}

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final String name;

  ProfileUpdated(this.name);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}