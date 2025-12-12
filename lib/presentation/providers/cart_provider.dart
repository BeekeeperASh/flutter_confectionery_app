import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/menu_item.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../../di/service_locator.dart';

final cartViewModelProvider = StateNotifierProvider<CartViewModel, CartState>(
  (ref) => ServiceLocator.getCartViewModel(),
);

final cartItemsCountProvider = Provider<int>((ref) {
  final cartState = ref.watch(cartViewModelProvider);

  if (cartState is CartLoaded) {
    return cartState.cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  return 0;
});

final cartTotalProvider = Provider<double>((ref) {
  final cartState = ref.watch(cartViewModelProvider);

  if (cartState is CartLoaded) {
    return cartState.cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  return 0.0;
});

final cartItemsProvider = Provider<List<CartItem>>((ref) {
  final cartState = ref.watch(cartViewModelProvider);

  if (cartState is CartLoaded) {
    return List.from(cartState.cartItems);
  }

  return [];
});

final isCartEmptyProvider = Provider<bool>((ref) {
  final cartState = ref.watch(cartViewModelProvider);

  if (cartState is CartLoaded) {
    return cartState.cartItems.isEmpty;
  }

  return true;
});

final cartItemByIdProvider = Provider.family<CartItem?, String>((
  ref,
  cartItemId,
) {
  final cartState = ref.watch(cartViewModelProvider);

  if (cartState is CartLoaded) {
    try {
      return cartState.cartItems.firstWhere((item) => item.id == cartItemId);
    } catch (e) {
      return null;
    }
  }

  return null;
});

final cartLoadingProvider = Provider<bool>((ref) {
  final cartState = ref.watch(cartViewModelProvider);
  return cartState is CartLoading;
});

final cartErrorProvider = Provider<String?>((ref) {
  final cartState = ref.watch(cartViewModelProvider);

  if (cartState is CartError) {
    return cartState.message;
  }

  return null;
});

final addToCartProvider = Provider<void Function(MenuItem)>((ref) {
  return (menuItem) {
    ref.read(cartViewModelProvider.notifier).addToCart(menuItem);
  };
});

final removeFromCartProvider = Provider<void Function(String)>((ref) {
  return (cartItemId) {
    ref.read(cartViewModelProvider.notifier).removeFromCart(cartItemId);
  };
});

final updateCartItemQuantityProvider = Provider<void Function(String, int)>((
  ref,
) {
  return (cartItemId, quantity) {
    ref
        .read(cartViewModelProvider.notifier)
        .updateQuantity(cartItemId, quantity);
  };
});

final clearCartProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(cartViewModelProvider.notifier).clearCart();
  };
});

final refreshCartProvider = FutureProvider<void>((ref) async {
  final notifier = ref.read(cartViewModelProvider.notifier);

  await notifier.loadCartItems();
});

final isItemInCartProvider = Provider.family<bool, String>((ref, menuItemId) {
  final cartState = ref.watch(cartViewModelProvider);

  if (cartState is CartLoaded) {
    return cartState.cartItems.any((item) => item.menuItemId == menuItemId);
  }

  return false;
});

final itemQuantityProvider = Provider.family<int, String>((ref, menuItemId) {
  final cartState = ref.watch(cartViewModelProvider);

  if (cartState is CartLoaded) {
    final item = cartState.cartItems.firstWhere(
      (item) => item.menuItemId == menuItemId,
      orElse: () =>
          CartItem(id: '', menuItemId: '', title: '', quantity: 0, price: 0),
    );
    return item.quantity;
  }

  return 0;
});

final cartSummaryProvider = Provider<CartSummary>((ref) {
  final cartState = ref.watch(cartViewModelProvider);

  if (cartState is CartLoaded) {
    final totalItems = cartState.cartItems.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
    final totalPrice = cartState.cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return CartSummary(
      itemCount: totalItems,
      totalPrice: totalPrice,
      isEmpty: cartState.cartItems.isEmpty,
    );
  }

  return CartSummary(itemCount: 0, totalPrice: 0.0, isEmpty: true);
});

class CartSummary {
  final int itemCount;
  final double totalPrice;
  final bool isEmpty;

  CartSummary({
    required this.itemCount,
    required this.totalPrice,
    required this.isEmpty,
  });
}
