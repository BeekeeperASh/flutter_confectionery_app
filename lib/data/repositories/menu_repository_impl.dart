import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/local/cache_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final CacheDataSource _cacheDataSource;

  MenuRepositoryImpl(this._cacheDataSource);

  @override
  Future<List<MenuItem>> getMenuItems() async {
    return await _cacheDataSource.getMenuItems();
  }

  @override
  Future<MenuItem> getMenuItemById(String id) async {
    final items = await _cacheDataSource.getMenuItems();
    return items.firstWhere((item) => item.id == id);
  }

  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    final items = await _cacheDataSource.getMenuItems();
    return items.where((item) => item.category == category).toList();
  }
}