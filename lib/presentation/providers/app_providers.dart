import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/menu_viewmodel.dart';
import '../viewmodels/order_viewmodel.dart';
import './auth_provider.dart';
import './menu_provider.dart';
import './cart_provider.dart';
import './order_provider.dart';
import './profile_provider.dart';

// Провайдер для инициализации приложения
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Инициализация всех необходимых провайдеров

  // Загружаем данные пользователя (используем публичные методы)
  final authNotifier = ref.read(authViewModelProvider.notifier);

  // Вместо вызова приватного метода используем подход через состояние
  // или добавляем публичный метод в AuthViewModel
  // Для демонстрации просто подождем немного
  await Future.delayed(const Duration(milliseconds: 100));

  // Загружаем меню
  final menuNotifier = ref.read(menuViewModelProvider.notifier);
  menuNotifier.loadMenuItems();

  // Загружаем заказы
  final orderNotifier = ref.read(orderViewModelProvider.notifier);
  orderNotifier.loadOrders();

  // Корзина инициализируется автоматически в конструкторе CartViewModel
  // через вызов loadCartItems()
});

// Провайдер для проверки состояния инициализации
final isAppInitializedProvider = Provider<bool>((ref) {
  final initializationState = ref.watch(appInitializationProvider);
  return !initializationState.isLoading && initializationState.hasValue;
});

// Провайдер для получения текущего пользователя
final currentUserProvider = Provider<String?>((ref) {
  final authState = ref.watch(authViewModelProvider);

  if (authState is AuthAuthenticated) {
    return authState.user.name;
  }

  return null;
});

// Провайдер для проверки авторизации
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authViewModelProvider);
  return authState is AuthAuthenticated;
});

// Провайдер для получения ошибки авторизации
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authViewModelProvider);

  if (authState is AuthError) {
    return authState.message;
  }

  return null;
});

// Провайдер для состояния загрузки
final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authViewModelProvider);
  final menuState = ref.watch(menuViewModelProvider);
  final orderState = ref.watch(orderViewModelProvider);

  return authState is AuthLoading ||
      menuState is MenuLoading ||
      orderState is OrderLoading;
});

// Провайдер для получения всех ошибок
final allErrorsProvider = Provider<List<String>>((ref) {
  final errors = <String>[];

  final authState = ref.watch(authViewModelProvider);
  final menuState = ref.watch(menuViewModelProvider);
  final cartState = ref.watch(cartViewModelProvider);
  final orderState = ref.watch(orderViewModelProvider);

  if (authState is AuthError) {
    errors.add('Авторизация: ${authState.message}');
  }

  if (menuState is MenuError) {
    errors.add('Меню: ${menuState.message}');
  }

  if (cartState is CartError) {
    errors.add('Корзина: ${cartState.message}');
  }

  if (orderState is OrderError) {
    errors.add('Заказы: ${orderState.message}');
  }

  return errors;
});

// Провайдер для перезагрузки всех данных
final refreshAllDataProvider = FutureProvider<void>((ref) async {
  // Создаем список Future для параллельной загрузки
  final futures = <Future>[];

  // Загружаем меню
  futures.add(ref.read(menuViewModelProvider.notifier).loadMenuItems());

  // Загружаем заказы
  futures.add(ref.read(orderViewModelProvider.notifier).loadOrders());

  // Загружаем корзину (если есть публичный метод)
  final cartNotifier = ref.read(cartViewModelProvider.notifier);
  futures.add(cartNotifier.loadCartItems());

  // Выполняем все загрузки параллельно
  await Future.wait(futures);
});

// Провайдер для общей сводки приложения
final appSummaryProvider = Provider<AppSummary>((ref) {
  final userName = ref.watch(currentUserProvider) ?? 'Гость';
  final cartCount = ref.watch(cartItemsCountProvider);
  final orderCount = ref.watch(orderViewModelProvider.select(
        (state) => state is OrderLoaded ? state.orders.length : 0,
  ));
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  final isLoading = ref.watch(isLoadingProvider);

  return AppSummary(
    userName: userName,
    cartItemsCount: cartCount,
    ordersCount: orderCount,
    isAuthenticated: isAuthenticated,
    isLoading: isLoading,
  );
});

// Модель для сводки приложения
class AppSummary {
  final String userName;
  final int cartItemsCount;
  final int ordersCount;
  final bool isAuthenticated;
  final bool isLoading;

  AppSummary({
    required this.userName,
    required this.cartItemsCount,
    required this.ordersCount,
    required this.isAuthenticated,
    required this.isLoading,
  });

  @override
  String toString() {
    return 'AppSummary(userName: $userName, cartItemsCount: $cartItemsCount, ordersCount: $ordersCount, isAuthenticated: $isAuthenticated, isLoading: $isLoading)';
  }
}

// Провайдер для навигационных проверок
final navigationGuardProvider = Provider<bool>((ref) {
  final isInitialized = ref.watch(isAppInitializedProvider);
  final isLoading = ref.watch(isLoadingProvider);
  final errors = ref.watch(allErrorsProvider);

  // Возвращаем true если можно навигировать
  return isInitialized && !isLoading && errors.isEmpty;
});