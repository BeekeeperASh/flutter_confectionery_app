import '../../domain/entities/order.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/local/cache_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final CacheDataSource _cacheDataSource;

  OrderRepositoryImpl(this._cacheDataSource);

  @override
  Future<Order> createOrder(List<CartItem> items, String? comment) async {
    await _cacheDataSource.createOrder(items, comment);
    final orders = await _cacheDataSource.getOrders();
    return orders.first;
  }

  @override
  Future<List<Order>> getOrders() async {
    return await _cacheDataSource.getOrders();
  }

  @override
  Future<Order> getOrderById(String id) async {
    final orders = await _cacheDataSource.getOrders();
    return orders.firstWhere((order) => order.id == id);
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}