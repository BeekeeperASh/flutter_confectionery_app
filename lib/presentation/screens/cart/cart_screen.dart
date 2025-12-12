import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/cart_provider.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../widgets/cart_item_tile.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartViewModelProvider);
    final cartTotal = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(context, ref, cartState, cartTotal),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
    double cartTotal,
  ) {
    if (cartState is CartLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cartState is CartError) {
      return Center(child: Text('Ошибка: ${cartState.message}'));
    }

    if (cartState is CartLoaded) {
      if (cartState.cartItems.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Ваша корзина пуста\nДобавьте товары из меню',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      }

      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartState.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartState.cartItems[index];
                return CartItemTile(
                  item: item,
                  onRemove: () => ref
                      .read(cartViewModelProvider.notifier)
                      .removeFromCart(item.id),
                  onUpdateQuantity: (quantity) {
                    if (quantity > 0) {
                      ref
                          .read(cartViewModelProvider.notifier)
                          .updateQuantity(item.id, quantity);
                    } else {
                      ref
                          .read(cartViewModelProvider.notifier)
                          .removeFromCart(item.id);
                    }
                  },
                );
              },
            ),
          ),

          _buildTotalPanel(
            context,
            ref,
            cartTotal,
            cartState.cartItems.isNotEmpty,
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildTotalPanel(
    BuildContext context,
    WidgetRef ref,
    double total,
    bool hasItems,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Итого:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${total.toInt()} ₽',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: hasItems
                      ? () =>
                            ref.read(cartViewModelProvider.notifier).clearCart()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Очистить'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: hasItems ? () => context.push('/checkout') : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Оформить заказ'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
