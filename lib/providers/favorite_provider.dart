import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/database_helper.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FavoriteProvider({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _databaseHelper.getFavorites();
    } catch (e) {
      _favorites = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((restaurant) => restaurant.id == id);
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (isFavorite(restaurant.id)) {
      await _databaseHelper.removeFavorite(restaurant.id);
    } else {
      await _databaseHelper.insertFavorite(restaurant);
    }
    await loadFavorites();
  }

  Future<void> addFavoriteFromDetail(RestaurantDetail detail) async {
    final restaurant = Restaurant(
      id: detail.id,
      name: detail.name,
      description: detail.description,
      pictureId: detail.pictureId,
      city: detail.city,
      rating: detail.rating,
    );
    await toggleFavorite(restaurant);
  }
}
