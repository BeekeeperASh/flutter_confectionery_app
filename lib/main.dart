import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/menu/menu_screen.dart';
import 'presentation/screens/cart/cart_screen.dart';
import 'presentation/screens/order/checkout_screen.dart';
import 'presentation/screens/order/orders_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/profile/edit_profile_screen.dart';
import 'presentation/screens/notifications/notifications_screen.dart';
import 'presentation/screens/payment/payment_methods_screen.dart';
import 'presentation/screens/promotions/promotions_screen.dart';
import 'di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sweet Delights',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/auth',
  routes: [
    // Авторизация
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),

    // Главное меню
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),

    // Корзина
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),

    // Оформление заказа
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),

    // История заказов
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
    ),

    // Профиль
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // Редактирование профиля
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),

    // Уведомления
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    // Способы оплаты
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentMethodsScreen(),
    ),

    // Акции и промокоды
    GoRoute(
      path: '/promotions',
      builder: (context, state) => const PromotionsScreen(),
    ),
  ],
);