import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../../di/service_locator.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
      (ref) => ServiceLocator.getAuthViewModel(),
);