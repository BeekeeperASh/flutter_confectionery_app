import '../../../domain/entities/notification.dart';

abstract class NotificationDataSource {
  Future<List<Notification>> getNotifications();
  Future<void> saveNotifications(List<Notification> notifications);
}

class NotificationDataSourceImpl implements NotificationDataSource {
  List<Notification> _notifications = [];

  @override
  Future<List<Notification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_notifications);
  }

  @override
  Future<void> saveNotifications(List<Notification> notifications) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _notifications = List.from(notifications);
  }
}