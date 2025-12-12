import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/usecases/notification_usecases.dart';

class NotificationViewModel extends StateNotifier<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final AddNotificationUseCase _addNotificationUseCase;
  final MarkNotificationAsReadUseCase _markAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase _markAllAsReadUseCase;
  final ClearNotificationsUseCase _clearNotificationsUseCase;
  final GetUnreadNotificationsCountUseCase _getUnreadCountUseCase;

  NotificationViewModel(
      this._getNotificationsUseCase,
      this._addNotificationUseCase,
      this._markAsReadUseCase,
      this._markAllAsReadUseCase,
      this._clearNotificationsUseCase,
      this._getUnreadCountUseCase,
      ) : super(NotificationInitial()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = NotificationLoading();
    try {
      final notifications = await _getNotificationsUseCase.execute();
      state = NotificationLoaded(notifications);
    } catch (e) {
      state = NotificationError(e.toString());
    }
  }

  Future<void> addNotification({
    required String title,
    required String message,
    required String type,
  }) async {
    try {
      await _addNotificationUseCase.execute(
        title: title,
        message: message,
        type: type,
      );
      await loadNotifications();
    } catch (e) {
      state = NotificationError(e.toString());
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _markAsReadUseCase.execute(notificationId);
      await loadNotifications();
    } catch (e) {
      state = NotificationError(e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _markAllAsReadUseCase.execute();
      await loadNotifications();
    } catch (e) {
      state = NotificationError(e.toString());
    }
  }

  Future<void> clearNotifications() async {
    try {
      await _clearNotificationsUseCase.execute();
      state = NotificationLoaded([]);
    } catch (e) {
      state = NotificationError(e.toString());
    }
  }

  Future<int> getUnreadCount() async {
    try {
      return await _getUnreadCountUseCase.execute();
    } catch (e) {
      return 0;
    }
  }
}

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<Notification> notifications;

  NotificationLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}