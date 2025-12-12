import '../entities/cart_item.dart';
import '../entities/menu_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addToCart(MenuItem item);
  Future<void> removeFromCart(String cartItemId);
  Future<void> updateQuantity(String cartItemId, int quantity);
  Future<void> clearCart();
  Future<double> getCartTotal();
  Future<int> getCartItemsCount();
  Future<bool> isItemInCart(String menuItemId);
  Future<int> getItemQuantity(String menuItemId);
}