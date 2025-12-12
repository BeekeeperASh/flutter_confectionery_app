import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';
import '../../providers/order_provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/order_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    final TextEditingController nameController = TextEditingController(
      text: currentName,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Изменить имя'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Имя',
              border: OutlineInputBorder(),
              hintText: 'Введите ваше имя',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty && newName != currentName) {
                  Navigator.pop(context);
                  _showSuccessMessage(context, 'Имя изменено на: $newName');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showConfirmLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выход из аккаунта'),
          content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performLogout(context, ref);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Выйти'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authViewModelProvider.notifier).logout();

      if (context.mounted) {
        _showSuccessMessage(context, 'Вы успешно вышли из аккаунта');
        context.go('/auth');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при выходе: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final appSummary = ref.watch(appSummaryProvider);
    final orderState = ref.watch(orderViewModelProvider);

    int ordersCount = 0;
    if (orderState is OrderLoaded) {
      ordersCount = orderState.orders.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (authState is AuthAuthenticated)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  _showEditNameDialog(context, ref, authState.user.name),
              tooltip: 'Редактировать профиль',
            ),
        ],
      ),
      body: _buildBody(authState, appSummary, ordersCount, context, ref),
    );
  }

  Widget _buildBody(
    AuthState authState,
    AppSummary appSummary,
    int ordersCount,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (authState is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (authState is AuthError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Ошибка: ${authState.message}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Вернуться'),
            ),
          ],
        ),
      );
    }

    if (authState is AuthAuthenticated) {
      return _buildAuthenticatedProfile(
        authState,
        appSummary,
        ordersCount,
        context,
        ref,
      );
    }

    return _buildUnauthenticatedProfile(context, ref);
  }

  Widget _buildAuthenticatedProfile(
    AuthAuthenticated authState,
    AppSummary appSummary,
    int ordersCount,
    BuildContext context,
    WidgetRef ref,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.pink, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      authState.user.name.isNotEmpty
                          ? authState.user.name[0].toUpperCase()
                          : 'П',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  authState.user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Chip(
                  label: const Text(
                    'Авторизован',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.shopping_cart,
                      label: 'Товаров в корзине',
                      value: appSummary.cartItemsCount.toString(),
                    ),
                    _buildStatItem(
                      icon: Icons.receipt_long,
                      label: 'Всего заказов',
                      value: ordersCount.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        _buildSection(
          title: 'Настройки аккаунта',
          children: [
            _buildListTile(
              icon: Icons.person_outline,
              title: 'Редактировать профиль',
              subtitle: 'Изменить имя и контактные данные',
              onTap: () => context.push('/profile/edit'),
            ),
            _buildListTile(
              icon: Icons.notifications_outlined,
              title: 'Уведомления',
              subtitle: 'Настройка оповещений',
              onTap: () => context.push('/notifications'),
            ),
            _buildListTile(
              icon: Icons.location_on_outlined,
              title: 'Адреса доставки',
              subtitle: 'Управление адресами',
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildSection(
          title: 'Заказы и покупки',
          children: [
            _buildListTile(
              icon: Icons.receipt_long_outlined,
              title: 'История заказов',
              subtitle: 'Просмотр всех заказов',
              onTap: () => context.push('/orders'),
            ),
            _buildListTile(
              icon: Icons.local_offer_outlined,
              title: 'Промокоды и скидки',
              subtitle: 'Актуальные предложения',
              onTap: () => context.push('/promotions'),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildSection(
          title: 'Оплата и безопасность',
          children: [
            _buildListTile(
              icon: Icons.payment_outlined,
              title: 'Способы оплаты',
              subtitle: 'Банковские карты и кошельки',
              onTap: () => context.push('/payment'),
            ),
            _buildListTile(
              icon: Icons.security_outlined,
              title: 'Безопасность',
              subtitle: 'Настройки безопасности аккаунта',
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildSection(
          title: 'Поддержка',
          children: [
            _buildListTile(
              icon: Icons.help_outline,
              title: 'Помощь',
              subtitle: 'Часто задаваемые вопросы',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.headset_mic_outlined,
              title: 'Служба поддержки',
              subtitle: 'Свяжитесь с нами',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.info_outline,
              title: 'О приложении',
              subtitle: 'Версия 1.0.0',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Sweet Delights',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      '© 2024 Sweet Delights. Все права защищены.',
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 32),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: () => _showConfirmLogoutDialog(context, ref),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.red.shade300),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout),
                SizedBox(width: 12),
                Text(
                  'Выйти из аккаунта',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUnauthenticatedProfile(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Вы не авторизованы',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Авторизуйтесь, чтобы получить доступ ко всем функциям профиля',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.go('/auth'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Войти в аккаунт',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => context.go('/menu'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.pink),
                ),
                child: const Text(
                  'Продолжить как гость',
                  style: TextStyle(fontSize: 16, color: Colors.pink),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Card(child: Column(children: children)),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.pink),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
