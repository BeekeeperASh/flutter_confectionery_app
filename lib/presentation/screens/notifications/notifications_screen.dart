import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/notification_provider.dart';
import '../../viewmodels/notification_viewmodel.dart';
import '../../widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _refreshNotifications(WidgetRef ref) async {
    await ref.read(notificationViewModelProvider.notifier).loadNotifications();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationViewModelProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Уведомления'),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.mark_email_read),
              onPressed: () => ref.read(notificationViewModelProvider.notifier).markAllAsRead(),
              tooltip: 'Отметить все как прочитанные',
            ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearConfirmation(context, ref),
            tooltip: 'Очистить все уведомления',
          ),
        ],
      ),
      body: _buildBody(notificationState, ref),
    );
  }

  Widget _buildBody(NotificationState notificationState, WidgetRef ref) {
    if (notificationState is NotificationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notificationState is NotificationError) {
      return Center(child: Text('Ошибка: ${notificationState.message}'));
    }

    if (notificationState is NotificationLoaded) {
      if (notificationState.notifications.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'У вас нет уведомлений',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => _refreshNotifications(ref),
        child: ListView.builder(
          itemCount: notificationState.notifications.length,
          itemBuilder: (context, index) {
            final notification = notificationState.notifications[index];
            return NotificationTile(
              notification: notification,
              onTap: () => ref.read(notificationViewModelProvider.notifier).markAsRead(notification.id),
            );
          },
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить все уведомления?'),
        content: const Text('Это действие невозможно отменить. Все уведомления будут удалены.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(notificationViewModelProvider.notifier).clearNotifications();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Все уведомления очищены'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }
}