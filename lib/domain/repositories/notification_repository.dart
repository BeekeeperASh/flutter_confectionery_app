import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotifications();
  Future<void> addNotification(Notification notification);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> clearNotifications();
  Future<int> getUnreadCount();
}