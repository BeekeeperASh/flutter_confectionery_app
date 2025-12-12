import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/usecases/menu_usecases.dart';

class MenuViewModel extends StateNotifier<MenuState> {
  final GetMenuItemsUseCase _getMenuItemsUseCase;

  MenuViewModel(this._getMenuItemsUseCase) : super(MenuInitial()) {
    loadMenuItems();
  }

  Future<void> loadMenuItems() async {
    if (state is MenuLoading) return;

    state = MenuLoading();
    try {
      final menuItems = await _getMenuItemsUseCase.execute();
      state = MenuLoaded(menuItems);
    } catch (e) {
      state = MenuError(e.toString());
    }
  }

  MenuItem? getMenuItemById(String id) {
    if (state is MenuLoaded) {
      final loadedState = state as MenuLoaded;
      try {
        return loadedState.menuItems.firstWhere((item) => item.id == id);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  List<MenuItem> getMenuItemsByCategory(String category) {
    if (state is MenuLoaded) {
      final loadedState = state as MenuLoaded;
      return loadedState.menuItems
          .where((item) => item.category == category)
          .toList();
    }
    return [];
  }

  bool get isLoading => state is MenuLoading;
  bool get hasError => state is MenuError;
  bool get isLoaded => state is MenuLoaded;

  String? get errorMessage {
    if (state is MenuError) {
      return (state as MenuError).message;
    }
    return null;
  }

  List<MenuItem> get menuItems {
    if (state is MenuLoaded) {
      return (state as MenuLoaded).menuItems;
    }
    return [];
  }
}

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> menuItems;

  MenuLoaded(this.menuItems);
}

class MenuError extends MenuState {
  final String message;

  MenuError(this.message);
}