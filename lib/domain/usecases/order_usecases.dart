import '../entities/order.dart';
import '../repositories/order_repository.dart';
import '../entities/cart_item.dart';

class CreateOrderUseCase {
  final OrderRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<void> execute(List<CartItem> items, String? comment) async {
    await _repository.createOrder(items, comment);
  }
}

class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<List<Order>> execute() async {
    return await _repository.getOrders();
  }
}