import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/service_locator.dart';
import '../viewmodels/menu_viewmodel.dart';

final menuViewModelProvider = StateNotifierProvider<MenuViewModel, MenuState>(
      (ref) => ServiceLocator.getMenuViewModel(),
);