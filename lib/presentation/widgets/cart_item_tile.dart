import 'package:flutter/material.dart';
import '../../../domain/entities/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onRemove;
  final Function(int)? onUpdateQuantity;
  final bool showActions;

  const CartItemTile({
    super.key,
    required this.item,
    this.onRemove,
    this.onUpdateQuantity,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade100,
          child: const Icon(Icons.cake, color: Colors.pink),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${item.price.toInt()} ₽ × ${item.quantity}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Итого: ${(item.price * item.quantity).toInt()} ₽',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: showActions && onUpdateQuantity != null
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Кнопка уменьшения количества
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                final newQuantity = item.quantity - 1;
                if (newQuantity > 0) {
                  onUpdateQuantity!(newQuantity);
                } else {
                  onRemove?.call();
                }
              },
            ),

            // Отображение количества
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${item.quantity}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Кнопка увеличения количества
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                onUpdateQuantity!(item.quantity + 1);
              },
            ),

            // Кнопка удаления (отдельно)
            if (onRemove != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onRemove,
                tooltip: 'Удалить из корзины',
              ),
          ],
        )
            : null,
      ),
    );
  }
}