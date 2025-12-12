import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/order_provider.dart';
import '../../viewmodels/order_viewmodel.dart';
import '../../widgets/order_tile.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заказы'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu'),
        ),
      ),
      body: _buildBody(orderState, ref),
    );
  }

  Widget _buildBody(OrderState orderState, WidgetRef ref) {
    if (orderState is OrderLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orderState is OrderError) {
      return Center(child: Text('Ошибка: ${orderState.message}'));
    }

    if (orderState is OrderLoaded) {
      if (orderState.orders.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'У вас еще нет заказов\nОформите первый заказ в корзине',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(orderViewModelProvider.notifier).loadOrders();
        },
        child: ListView.builder(
          itemCount: orderState.orders.length,
          itemBuilder: (context, index) {
            final order = orderState.orders[index];
            return OrderTile(order: order);
          },
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}