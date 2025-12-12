import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.pink,
                child: Icon(
                  Icons.cake,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Sweet Delights',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Кондитерская',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48),

              if (authState is! AuthLoading)
                _buildLoginButton(context, ref)
              else
                const CircularProgressIndicator(),

              const SizedBox(height: 16),

              if (authState is! AuthLoading)
                _buildGuestButton(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(authViewModelProvider.notifier).login('Алексей');
          if (context.mounted) {
            context.go('/menu');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Войти в приложение',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildGuestButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () async {
          await ref.read(authViewModelProvider.notifier).login('Гость');
          if (context.mounted) {
            context.go('/menu');
          }
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.pink),
        ),
        child: const Text(
          'Продолжить как гость',
          style: TextStyle(
            fontSize: 18,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }
}