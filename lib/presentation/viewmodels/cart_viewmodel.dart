import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/usecases/cart_usecases.dart';

class CartViewModel extends StateNotifier<CartState> {
  final GetCartItemsUseCase _getCartItemsUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final UpdateCartItemQuantityUseCase _updateQuantityUseCase;

  CartViewModel(
      this._getCartItemsUseCase,
      this._addToCartUseCase,
      this._removeFromCartUseCase,
      this._clearCartUseCase,
      this._updateQuantityUseCase,
      ) : super(CartInitial()) {
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    state = CartLoading();
    try {
      final cartItems = await _getCartItemsUseCase.execute();
      state = CartLoaded(cartItems);
    } catch (e) {
      state = CartError(e.toString());
    }
  }

  Future<void> addToCart(MenuItem item) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      state = CartLoading();
    }

    try {
      await _addToCartUseCase.execute(item);
      await loadCartItems();
    } catch (e) {
      state = CartError(e.toString());
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedItems = currentState.cartItems.where((item) => item.id != cartItemId).toList();
      state = CartLoaded(updatedItems);
    }

    try {
      await _removeFromCartUseCase.execute(cartItemId);
      await loadCartItems();
    } catch (e) {
      if (state is CartLoaded) {
        await loadCartItems();
      }
    }
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      if (quantity > 0) {
        await _updateQuantityUseCase.execute(cartItemId, quantity);
      } else {
        await _removeFromCartUseCase.execute(cartItemId);
      }
      await loadCartItems();
    } catch (e) {
      state = CartError(e.toString());
    }
  }

  Future<void> clearCart() async {
    final currentState = state;
    if (currentState is CartLoaded) {
      state = CartLoaded([]);
    }

    try {
      await _clearCartUseCase.execute();
      state = CartLoaded([]);
    } catch (e) {
      state = CartError(e.toString());
    }
  }

  int getTotalItemsCount() {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      return currentState.cartItems.fold(0, (sum, item) => sum + item.quantity);
    }
    return 0;
  }

  double getTotalPrice() {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      return currentState.cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    }
    return 0.0;
  }

  bool isItemInCart(String menuItemId) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      return currentState.cartItems.any((item) => item.menuItemId == menuItemId);
    }
    return false;
  }

  int getItemQuantity(String menuItemId) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = currentState.cartItems.firstWhere(
            (item) => item.menuItemId == menuItemId,
        orElse: () => CartItem(
          id: '',
          menuItemId: '',
          title: '',
          quantity: 0,
          price: 0.0,
        ),
      );
      return item.quantity;
    }
    return 0;
  }
}

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}