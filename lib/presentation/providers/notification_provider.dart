import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../../di/service_locator.dart';

final notificationViewModelProvider =
    StateNotifierProvider<NotificationViewModel, NotificationState>(
      (ref) => ServiceLocator.getNotificationViewModel(),
    );

final notificationsProvider = Provider<List<Notification>>((ref) {
  final notificationState = ref.watch(notificationViewModelProvider);

  if (notificationState is NotificationLoaded) {
    return notificationState.notifications;
  }

  return [];
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notificationState = ref.watch(notificationViewModelProvider);

  if (notificationState is NotificationLoaded) {
    return notificationState.notifications
        .where((notification) => !notification.isRead)
        .length;
  }

  return 0;
});

final addOrderNotificationProvider = Provider<void Function()>((ref) {
  return () {
    ref
        .read(notificationViewModelProvider.notifier)
        .addNotification(
          title: 'Заказ оформлен',
          message: 'Ваш заказ успешно оформлен и принят в обработку',
          type: 'order',
        );
  };
});

final addProfileNotificationProvider = Provider<void Function()>((ref) {
  return () {
    ref
        .read(notificationViewModelProvider.notifier)
        .addNotification(
          title: 'Профиль обновлен',
          message: 'Ваши данные профиля были успешно обновлены',
          type: 'profile',
        );
  };
});

final addPromotionNotificationProvider = Provider<void Function()>((ref) {
  return () {
    ref
        .read(notificationViewModelProvider.notifier)
        .addNotification(
          title: 'Новая акция',
          message: 'Скидка 10% на все десерты этой недели!',
          type: 'promotion',
        );
  };
});

final markNotificationAsReadProvider = Provider<void Function(String)>((ref) {
  return (notificationId) {
    ref.read(notificationViewModelProvider.notifier).markAsRead(notificationId);
  };
});

final markAllNotificationsAsReadProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(notificationViewModelProvider.notifier).markAllAsRead();
  };
});

final clearNotificationsProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(notificationViewModelProvider.notifier).clearNotifications();
  };
});

final refreshNotificationsProvider = FutureProvider<void>((ref) async {
  await ref.read(notificationViewModelProvider.notifier).loadNotifications();
});
