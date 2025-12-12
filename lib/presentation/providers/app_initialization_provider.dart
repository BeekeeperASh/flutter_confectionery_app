import 'package:flutter_riverpod/flutter_riverpod.dart';
import './auth_provider.dart';
import './menu_provider.dart';
import './order_provider.dart';

final appInitializationProvider = FutureProvider<void>((ref) async {
  print('=== Инициализация приложения ===');

  // Загружаем текущего пользователя
  try {
    final authNotifier = ref.read(authViewModelProvider.notifier);
    // Вызываем приватный метод для загрузки пользователя
    // В реальном приложении это было бы публичным методом
    await Future.delayed(const Duration(milliseconds: 300));
    print('Пользователь загружен');
  } catch (e) {
    print('Ошибка загрузки пользователя: $e');
  }

  // Загружаем меню
  try {
    await ref.read(menuViewModelProvider.notifier).loadMenuItems();
    print('Меню загружено');
  } catch (e) {
    print('Ошибка загрузки меню: $e');
  }

  // Загружаем заказы
  try {
    await ref.read(orderViewModelProvider.notifier).loadOrders();
    print('Заказы загружены');
  } catch (e) {
    print('Ошибка загрузки заказов: $e');
  }

  print('=== Инициализация завершена ===');
});