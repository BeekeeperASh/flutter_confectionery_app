import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class GetMenuItemsUseCase {
  final MenuRepository _repository;

  GetMenuItemsUseCase(this._repository);

  Future<List<MenuItem>> execute() async {
    return await _repository.getMenuItems();
  }
}