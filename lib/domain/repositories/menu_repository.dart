import '../entities/menu_item.dart';

abstract class MenuRepository {
  Future<List<MenuItem>> getMenuItems();
  Future<MenuItem> getMenuItemById(String id);
  Future<List<MenuItem>> getMenuItemsByCategory(String category);
}