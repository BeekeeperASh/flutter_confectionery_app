import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/local/auth_local_datasource.dart';
import '../data/datasources/local/cache_datasource.dart';
import '../data/datasources/local/notification_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/menu_repository_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../data/repositories/order_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/menu_repository.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/repositories/notification_repository.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/usecases/auth_usecases.dart';
import '../domain/usecases/menu_usecases.dart';
import '../domain/usecases/cart_usecases.dart';
import '../domain/usecases/notification_usecases.dart';
import '../domain/usecases/order_usecases.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';
import '../presentation/viewmodels/menu_viewmodel.dart';
import '../presentation/viewmodels/cart_viewmodel.dart';
import '../presentation/viewmodels/notification_viewmodel.dart';
import '../presentation/viewmodels/order_viewmodel.dart';
import '../presentation/viewmodels/profile_viewmodel.dart';

class ServiceLocator {
  static AuthLocalDataSource? _authLocalDataSource;
  static CacheDataSource? _cacheDataSource;

  static AuthRepository? _authRepository;
  static MenuRepository? _menuRepository;
  static CartRepository? _cartRepository;
  static OrderRepository? _orderRepository;

  static LoginUseCase? _loginUseCase;
  static LogoutUseCase? _logoutUseCase;
  static GetCurrentUserUseCase? _getCurrentUserUseCase;
  static UpdateUserUseCase? _updateUserUseCase;
  static GetMenuItemsUseCase? _getMenuItemsUseCase;
  static GetCartItemsUseCase? _getCartItemsUseCase;
  static AddToCartUseCase? _addToCartUseCase;
  static RemoveFromCartUseCase? _removeFromCartUseCase;
  static ClearCartUseCase? _clearCartUseCase;
  static CreateOrderUseCase? _createOrderUseCase;
  static GetOrdersUseCase? _getOrdersUseCase;
  static UpdateCartItemQuantityUseCase? _updateCartItemQuantityUseCase;
  static GetCartTotalUseCase? _getCartTotalUseCase;
  static GetCartItemsCountUseCase? _getCartItemsCountUseCase;

  static NotificationDataSource? _notificationDataSource;
  static NotificationRepository? _notificationRepository;

  static GetNotificationsUseCase? _getNotificationsUseCase;
  static AddNotificationUseCase? _addNotificationUseCase;
  static MarkNotificationAsReadUseCase? _markNotificationAsReadUseCase;
  static MarkAllNotificationsAsReadUseCase? _markAllNotificationsAsReadUseCase;
  static ClearNotificationsUseCase? _clearNotificationsUseCase;
  static GetUnreadNotificationsCountUseCase? _getUnreadNotificationsCountUseCase;

  static Future<void> init() async {
    // Data Sources
    _authLocalDataSource = AuthLocalDataSourceImpl();
    _cacheDataSource = CacheDataSource();

    // Repositories
    _authRepository = AuthRepositoryImpl(_authLocalDataSource!);
    _menuRepository = MenuRepositoryImpl(_cacheDataSource!);
    _cartRepository = CartRepositoryImpl(_cacheDataSource!);
    _orderRepository = OrderRepositoryImpl(_cacheDataSource!);

    // Use Cases
    _loginUseCase = LoginUseCase(_authRepository!);
    _logoutUseCase = LogoutUseCase(_authRepository!);
    _getCurrentUserUseCase = GetCurrentUserUseCase(_authRepository!);
    _updateUserUseCase = UpdateUserUseCase(_authRepository!);
    _getMenuItemsUseCase = GetMenuItemsUseCase(_menuRepository!);
    _getCartItemsUseCase = GetCartItemsUseCase(_cartRepository!);
    _addToCartUseCase = AddToCartUseCase(_cartRepository!);
    _removeFromCartUseCase = RemoveFromCartUseCase(_cartRepository!);
    _clearCartUseCase = ClearCartUseCase(_cartRepository!);
    _createOrderUseCase = CreateOrderUseCase(_orderRepository!);
    _getOrdersUseCase = GetOrdersUseCase(_orderRepository!);

    _updateCartItemQuantityUseCase = UpdateCartItemQuantityUseCase(_cartRepository!);
    _getCartTotalUseCase = GetCartTotalUseCase(_cartRepository!);
    _getCartItemsCountUseCase = GetCartItemsCountUseCase(_cartRepository!);

    _notificationDataSource = NotificationDataSourceImpl();
    _notificationRepository = NotificationRepositoryImpl(_notificationDataSource!);

    _getNotificationsUseCase = GetNotificationsUseCase(_notificationRepository!);
    _addNotificationUseCase = AddNotificationUseCase(_notificationRepository!);
    _markNotificationAsReadUseCase = MarkNotificationAsReadUseCase(_notificationRepository!);
    _markAllNotificationsAsReadUseCase = MarkAllNotificationsAsReadUseCase(_notificationRepository!);
    _clearNotificationsUseCase = ClearNotificationsUseCase(_notificationRepository!);
    _getUnreadNotificationsCountUseCase = GetUnreadNotificationsCountUseCase(_notificationRepository!);
  }

  static AuthViewModel getAuthViewModel() {
    return AuthViewModel(
      _loginUseCase!,
      _logoutUseCase!,
      _getCurrentUserUseCase!,
    );
  }

  static MenuViewModel getMenuViewModel() {
    return MenuViewModel(_getMenuItemsUseCase!);
  }

  static CartViewModel getCartViewModel() {
    return CartViewModel(
      _getCartItemsUseCase!,
      _addToCartUseCase!,
      _removeFromCartUseCase!,
      _clearCartUseCase!,
      _updateCartItemQuantityUseCase!,
    );
  }

  static OrderViewModel getOrderViewModel() {
    return OrderViewModel(
      _createOrderUseCase!,
      _getOrdersUseCase!,
    );
  }

  static ProfileViewModel getProfileViewModel() {
    return ProfileViewModel(_updateUserUseCase!);
  }

  static NotificationViewModel getNotificationViewModel() {
    return NotificationViewModel(
      _getNotificationsUseCase!,
      _addNotificationUseCase!,
      _markNotificationAsReadUseCase!,
      _markAllNotificationsAsReadUseCase!,
      _clearNotificationsUseCase!,
      _getUnreadNotificationsCountUseCase!,
    );
  }
}