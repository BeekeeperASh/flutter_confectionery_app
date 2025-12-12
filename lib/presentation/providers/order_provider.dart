import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../viewmodels/order_viewmodel.dart';
import '../../di/service_locator.dart';

final orderViewModelProvider = StateNotifierProvider<OrderViewModel, OrderState>(
      (ref) => ServiceLocator.getOrderViewModel(),
);

final ordersProvider = Provider<List<Order>>((ref) {
  final orderState = ref.watch(orderViewModelProvider);

  if (orderState is OrderLoaded) {
    return orderState.orders;
  }

  return [];
});

final ordersLoadingProvider = Provider<bool>((ref) {
  final orderState = ref.watch(orderViewModelProvider);
  return orderState is OrderLoading;
});

final ordersErrorProvider = Provider<String?>((ref) {
  final orderState = ref.watch(orderViewModelProvider);

  if (orderState is OrderError) {
    return orderState.message;
  }

  return null;
});

final createOrderProvider = Provider<void Function(List<CartItem>, String?)>((ref) {
  return (items, comment) {
    ref.read(orderViewModelProvider.notifier).createOrder(items, comment);
  };
});

final loadOrdersProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(orderViewModelProvider.notifier).loadOrders();
  };
});

final orderByIdProvider = Provider.family<Order?, String>((ref, orderId) {
  final orderState = ref.watch(orderViewModelProvider);

  if (orderState is OrderLoaded) {
    try {
      return orderState.orders.firstWhere(
            (order) => order.id == orderId,
      );
    } catch (e) {
      return null;
    }
  }

  return null;
});

final hasOrdersProvider = Provider<bool>((ref) {
  final orderState = ref.watch(orderViewModelProvider);

  if (orderState is OrderLoaded) {
    return orderState.orders.isNotEmpty;
  }

  return false;
});

final refreshOrdersProvider = FutureProvider<void>((ref) async {
  await ref.read(orderViewModelProvider.notifier).loadOrders();
});