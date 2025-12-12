import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notification_provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/menu_viewmodel.dart';
import '../../widgets/menu_item_tile.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuViewModelProvider.notifier).loadMenuItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuViewModelProvider);
    final cartCount = ref.watch(cartItemsCountProvider);
    final notificationCount = ref.watch(unreadNotificationsCountProvider);

    String userName = 'Гость';
    final authState = ref.watch(authViewModelProvider);
    if (authState is AuthAuthenticated) {
      userName = authState.user.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sweet Delights'),
            Text(
              'Привет, $userName!',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: _buildAppBarActions(context, ref, cartCount, notificationCount),
      ),
      body: _buildBody(menuState, ref),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, WidgetRef ref, int cartCount, int notificationCount) {
    return [
      Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
          if (cartCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                radius: 8,
                child: Text(
                  cartCount.toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
        ],
      ),
      IconButton(
        icon: const Icon(Icons.history),
        onPressed: () => context.push('/orders'),
      ),
      Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push('/notifications'),
          ),
          if (notificationCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                radius: 8,
                child: Text(
                  notificationCount > 9 ? '9+' : notificationCount.toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
        ],
      ),
      IconButton(
        icon: const Icon(Icons.person),
        onPressed: () => context.push('/profile'),
      ),
    ];
  }

  Widget _buildBody(MenuState menuState, WidgetRef ref) {
    if (menuState is MenuLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загружаем меню...'),
          ],
        ),
      );
    }

    if (menuState is MenuError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              'Ошибка: ${menuState.message}',
              style: const TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(menuViewModelProvider.notifier).loadMenuItems(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (menuState is MenuLoaded) {
      if (menuState.menuItems.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cake, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Меню временно недоступно',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(menuViewModelProvider.notifier).loadMenuItems();
        },
        child: ListView.builder(
          itemCount: menuState.menuItems.length,
          itemBuilder: (context, index) {
            final item = menuState.menuItems[index];
            return MenuItemTile(
              item: item,
              onAddToCart: () => ref.read(cartViewModelProvider.notifier).addToCart(item),
            );
          },
        ),
      );
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Инициализация меню...'),
        ],
      ),
    );
  }
}