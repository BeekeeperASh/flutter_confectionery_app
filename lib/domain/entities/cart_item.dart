class CartItem {
  final String id;
  final String menuItemId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.menuItemId,
    required this.title,
    required this.quantity,
    required this.price,
  });

  CartItem copyWith({
    String? id,
    String? menuItemId,
    String? title,
    int? quantity,
    double? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}