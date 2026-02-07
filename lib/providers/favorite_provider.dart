import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Restaurant> _favorites = [];

  List<Restaurant> get favorites => _favorites;

  bool isFavorite(String id) {
    return _favorites.any((restaurant) => restaurant.id == id);
  }

  void toggleFavorite(Restaurant restaurant) {
    final isExist = _favorites.any((item) => item.id == restaurant.id);
    if (isExist) {
      _favorites.removeWhere((item) => item.id == restaurant.id);
    } else {
      _favorites.add(restaurant);
    }
    notifyListeners();
  }
  
  void addFavorite(RestaurantDetail detail) {
    // Convert Detail to Restaurant (list item) for the favorite list
    final restaurant = Restaurant(
      id: detail.id,
      name: detail.name,
      description: detail.description,
      pictureId: detail.pictureId,
      city: detail.city,
      rating: detail.rating,
    );
    toggleFavorite(restaurant);
  }
}
