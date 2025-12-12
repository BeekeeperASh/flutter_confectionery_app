import '../repositories/notification_repository.dart';
import '../entities/notification.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<List<Notification>> execute() async {
    return await _repository.getNotifications();
  }
}

class AddNotificationUseCase {
  final NotificationRepository _repository;

  AddNotificationUseCase(this._repository);

  Future<void> execute({
    required String title,
    required String message,
    required String type,
  }) async {
    final notification = Notification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      message: message,
      createdAt: DateTime.now(),
      type: type,
    );

    await _repository.addNotification(notification);
  }
}

class MarkNotificationAsReadUseCase {
  final NotificationRepository _repository;

  MarkNotificationAsReadUseCase(this._repository);

  Future<void> execute(String notificationId) async {
    await _repository.markAsRead(notificationId);
  }
}

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepository _repository;

  MarkAllNotificationsAsReadUseCase(this._repository);

  Future<void> execute() async {
    await _repository.markAllAsRead();
  }
}

class ClearNotificationsUseCase {
  final NotificationRepository _repository;

  ClearNotificationsUseCase(this._repository);

  Future<void> execute() async {
    await _repository.clearNotifications();
  }
}

class GetUnreadNotificationsCountUseCase {
  final NotificationRepository _repository;

  GetUnreadNotificationsCountUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getUnreadCount();
  }
}