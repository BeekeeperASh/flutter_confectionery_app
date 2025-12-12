import '../../domain/entities/cart_item.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/local/cache_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CacheDataSource _cacheDataSource;

  CartRepositoryImpl(this._cacheDataSource);

  @override
  Future<void> addToCart(MenuItem item) async {
    await _cacheDataSource.addToCart(item);
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    return await _cacheDataSource.getCartItems();
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    await _cacheDataSource.removeFromCart(cartItemId);
  }

  @override
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await _cacheDataSource.updateQuantity(cartItemId, quantity);
  }

  @override
  Future<void> clearCart() async {
    await _cacheDataSource.clearCart();
  }

  @override
  Future<double> getCartTotal() async {
    return _cacheDataSource.getCartTotal();
  }

  @override
  Future<int> getCartItemsCount() async {
    return _cacheDataSource.getCartItemsCount();
  }

  @override
  Future<bool> isItemInCart(String menuItemId) async {
    final items = await _cacheDataSource.getCartItems();
    return items.any((item) => item.menuItemId == menuItemId);
  }

  @override
  Future<int> getItemQuantity(String menuItemId) async {
    final items = await _cacheDataSource.getCartItems();
    final item = items.firstWhere(
          (item) => item.menuItemId == menuItemId,
      orElse: () => CartItem(
        id: '',
        menuItemId: '',
        title: '',
        quantity: 0,
        price: 0,
      ),
    );
    return item.quantity;
  }
}