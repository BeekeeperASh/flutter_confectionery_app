import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/order_provider.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../widgets/cart_item_tile.dart';
import '../../providers/app_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedPaymentMethod = 'card';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userName = ref.read(currentUserProvider);
    _addressController.text = userName == 'Гость'
        ? 'Адрес не указан'
        : 'Москва, ул. Примерная, д. 1';
  }

  @override
  void dispose() {
    _commentController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _confirmOrder() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final cartItems = ref.read(cartItemsProvider);

    if (cartItems.isEmpty) {
      _showError('Корзина пуста');
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      _showError('Пожалуйста, укажите адрес доставки');
      return;
    }

    try {
      final comment = _commentController.text.trim().isNotEmpty
          ? _commentController.text.trim()
          : null;

      final fullComment = comment != null
          ? 'Адрес: ${_addressController.text.trim()}. Комментарий: $comment'
          : 'Адрес: ${_addressController.text.trim()}';

      await ref.read(orderViewModelProvider.notifier).createOrder(
        cartItems,
        fullComment,
      );

      ref.read(addOrderNotificationProvider)();

      ref.read(cartViewModelProvider.notifier).clearCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Заказ успешно оформлен!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      if (mounted) {
        context.go('/orders');
      }
    } catch (e) {
      _showError('Ошибка при оформлении заказа: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final cartState = ref.watch(cartViewModelProvider);
    final userName = ref.watch(currentUserProvider) ?? 'Гость';
    final appSummary = ref.watch(appSummaryProvider);

    if (cartState is CartLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (cartState is CartError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Оформление заказа'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: ${cartState.message}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Вернуться в корзину'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформление заказа'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(cartItems, cartTotal, userName, appSummary),
    );
  }

  Widget _buildBody(List<CartItem> cartItems, double cartTotal, String userName, AppSummary appSummary) {
    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Корзина пуста',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Вернуться к покупкам'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ваш заказ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Товаров: ${appSummary.cartItemsCount}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const Divider(height: 32),

                const Text(
                  'Состав заказа:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...cartItems.map((item) => CartItemTile(
                  item: item,
                  showActions: false,
                )).toList(),

                const Divider(height: 32),

                const Text(
                  'Информация о покупателе:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.pink),
                  title: const Text('Имя'),
                  subtitle: Text(userName),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Адрес доставки:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Введите адрес доставки',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Способ оплаты:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'card',
                      child: Row(
                        children: [
                          const Icon(Icons.credit_card, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text('Банковская карта'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'cash',
                      child: Row(
                        children: [
                          const Icon(Icons.money, color: Colors.green),
                          const SizedBox(width: 8),
                          const Text('Наличные при получении'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'wallet',
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_wallet, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text('Электронный кошелек'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedPaymentMethod = value);
                    }
                  },
                ),

                const SizedBox(height: 16),
                const Text(
                  'Комментарий к заказу:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText: 'Например: "Без орехов", "С собой", "Добавить свечу", "Позвонить перед доставкой"',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_commentController.text.length}/500 символов',
                  style: TextStyle(
                    fontSize: 12,
                    color: _commentController.text.length > 500 ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Итого к оплате:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${cartTotal.toInt()} ₽',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Включая стоимость доставки: 0 ₽',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle),
                      SizedBox(width: 8),
                      Text(
                        'Подтвердить заказ',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Нажимая кнопку, вы соглашаетесь с условиями оферты',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}