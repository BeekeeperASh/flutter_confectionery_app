import '../repositories/cart_repository.dart';
import '../entities/menu_item.dart';
import '../entities/cart_item.dart';

class AddToCartUseCase {
  final CartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<void> execute(MenuItem item) async {
    await _repository.addToCart(item);
  }
}

class GetCartItemsUseCase {
  final CartRepository _repository;

  GetCartItemsUseCase(this._repository);

  Future<List<CartItem>> execute() async {
    return await _repository.getCartItems();
  }
}

class RemoveFromCartUseCase {
  final CartRepository _repository;

  RemoveFromCartUseCase(this._repository);

  Future<void> execute(String cartItemId) async {
    await _repository.removeFromCart(cartItemId);
  }
}

class UpdateCartItemQuantityUseCase {
  final CartRepository _repository;

  UpdateCartItemQuantityUseCase(this._repository);

  Future<void> execute(String cartItemId, int quantity) async {
    await _repository.updateQuantity(cartItemId, quantity);
  }
}

class ClearCartUseCase {
  final CartRepository _repository;

  ClearCartUseCase(this._repository);

  Future<void> execute() async {
    await _repository.clearCart();
  }
}

class GetCartTotalUseCase {
  final CartRepository _repository;

  GetCartTotalUseCase(this._repository);

  Future<double> execute() async {
    return await _repository.getCartTotal();
  }
}

class GetCartItemsCountUseCase {
  final CartRepository _repository;

  GetCartItemsCountUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getCartItemsCount();
  }
}