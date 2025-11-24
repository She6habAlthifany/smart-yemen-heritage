// lib/core/services/favorites_manager.dart
import 'package:flutter/foundation.dart';

class FavoritesManager extends ChangeNotifier {
  FavoritesManager._private();
  static final FavoritesManager instance = FavoritesManager._private();

  final Set<String> _favoriteIds = {};

  bool isFavorite(String id) => _favoriteIds.contains(id);

  /// يبدّل حالة العنصر ويعلِن المستمعين
  void toggle(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  /// إضافة مباشرة (إن احتجت)
  void add(String id) {
    if (!_favoriteIds.contains(id)) {
      _favoriteIds.add(id);
      notifyListeners();
    }
  }

  /// إزالة مباشرة (إن احتجت)
  void remove(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
      notifyListeners();
    }
  }

  /// كل المعرفات المفضلة
  List<String> get all => List.unmodifiable(_favoriteIds);

  /// مسح الكل
  void clear() {
    _favoriteIds.clear();
    notifyListeners();
  }
}
