import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/usecases/order_usecases.dart';

class OrderViewModel extends StateNotifier<OrderState> {
  final CreateOrderUseCase _createOrderUseCase;
  final GetOrdersUseCase _getOrdersUseCase;

  OrderViewModel(
      this._createOrderUseCase,
      this._getOrdersUseCase,
      ) : super(OrderInitial());

  Future<void> createOrder(List<CartItem> items, String? comment) async {
    state = OrderLoading();
    try {
      await _createOrderUseCase.execute(items, comment);
      await loadOrders();
    } catch (e) {
      state = OrderError(e.toString());
    }
  }

  Future<void> loadOrders() async {
    state = OrderLoading();
    try {
      final orders = await _getOrdersUseCase.execute();
      state = OrderLoaded(orders);
    } catch (e) {
      state = OrderError(e.toString());
    }
  }
}

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> orders;

  OrderLoaded(this.orders);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}