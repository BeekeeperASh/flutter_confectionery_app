import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final DateTime createdAt;
  final double total;
  final String? comment;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.total,
    this.comment,
    this.status = 'pending',
  });
}