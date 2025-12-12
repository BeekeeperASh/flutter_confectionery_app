import '../entities/order.dart';
import '../entities/cart_item.dart';

abstract class OrderRepository {
  Future<Order> createOrder(List<CartItem> items, String? comment);
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(String id);
  Future<void> cancelOrder(String orderId);
}