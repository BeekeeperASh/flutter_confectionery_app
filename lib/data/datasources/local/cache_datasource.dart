import '../../../domain/entities/menu_item.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/order.dart';

class CacheDataSource {
  final List<MenuItem> _menuItems = [
    MenuItem(
      id: '1',
      title: 'Тирамису',
      description: 'Классический итальянский десерт с кофейной пропиткой',
      price: 320.0,
      category: 'Десерты',
      imageUrl: null,
    ),
    MenuItem(
      id: '2',
      title: 'Эклер',
      description: 'С заварным кремом и шоколадной глазурью',
      price: 180.0,
      category: 'Десерты',
      imageUrl: null,
    ),
    MenuItem(
      id: '3',
      title: 'Медовик',
      description: 'Нежный медовый торт со сметанным кремом',
      price: 280.0,
      category: 'Торты',
      imageUrl: null,
    ),
    MenuItem(
      id: '4',
      title: 'Макарунс',
      description: 'Французское миндальное пирожное',
      price: 150.0,
      category: 'Пирожные',
      imageUrl: null,
    ),
    MenuItem(
      id: '5',
      title: 'Чизкейк Нью-Йорк',
      description: 'Классический чизкейк с нежной текстурой',
      price: 350.0,
      category: 'Торты',
      imageUrl: null,
    ),
    MenuItem(
      id: '6',
      title: 'Птифур',
      description: 'Ассорти из мини-десертов',
      price: 420.0,
      category: 'Наборы',
      imageUrl: null,
    ),
  ];

  final List<CartItem> _cartItems = [];
  final List<Order> _orders = [];

  Future<List<MenuItem>> getMenuItems() async {
    // Имитация задержки сети
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_menuItems);
  }

  Future<void> addToCart(MenuItem item) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.menuItemId == item.id);
    if (existingIndex != -1) {
      final existingItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      _cartItems.add(CartItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        menuItemId: item.id,
        title: item.title,
        quantity: 1,
        price: item.price,
      ));
    }
  }

  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_cartItems);
  }

  Future<void> removeFromCart(String cartItemId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.removeWhere((item) => item.id == cartItemId);
  }

  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.clear();
  }

  Future<void> createOrder(List<CartItem> items, String? comment) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final order = Order(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      items: List.from(items),
      createdAt: DateTime.now(),
      total: items.fold(0, (sum, item) => sum + (item.price * item.quantity)),
      comment: comment,
      status: 'completed',
    );

    _orders.insert(0, order);
  }

  Future<List<Order>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_orders);
  }

  double getCartTotal() {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int getCartItemsCount() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      final item = _cartItems[index];
      if (quantity > 0) {
        _cartItems[index] = item.copyWith(quantity: quantity);
      } else {
        _cartItems.removeAt(index);
      }
    }
  }

  // Метод для отладки
  void printDebugInfo() {
    print('=== CacheDataSource Debug Info ===');
    print('Menu items: ${_menuItems.length}');
    print('Cart items: ${_cartItems.length}');
    print('Orders: ${_orders.length}');
    print('===============================');
  }
}