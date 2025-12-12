import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/local/notification_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<List<Notification>> getNotifications() async {
    return await _dataSource.getNotifications();
  }

  @override
  Future<void> addNotification(Notification notification) async {
    final notifications = await _dataSource.getNotifications();
    notifications.insert(0, notification);
    await _dataSource.saveNotifications(notifications);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final notifications = await _dataSource.getNotifications();
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].markAsRead();
      await _dataSource.saveNotifications(notifications);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final notifications = await _dataSource.getNotifications();
    final updatedNotifications = notifications.map((n) => n.markAsRead()).toList();
    await _dataSource.saveNotifications(updatedNotifications);
  }

  @override
  Future<void> clearNotifications() async {
    await _dataSource.saveNotifications([]);
  }

  @override
  Future<int> getUnreadCount() async {
    final notifications = await _dataSource.getNotifications();
    return notifications.where((n) => !n.isRead).length;
  }
}