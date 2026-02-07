import 'package:flutter/material.dart';
import '../models/api_state.dart';
import '../models/restaurant.dart';
import '../services/restaurant_api_service.dart';

class SearchProvider extends ChangeNotifier {
  final RestaurantApiService _apiService = RestaurantApiService();
  
  ApiState<List<Restaurant>> _state = const Loading();
  ApiState<List<Restaurant>> get state => _state;

  String _query = '';
  String get query => _query;

  Future<void> searchRestaurants(String query) async {
    _query = query;
    _state = const Loading();
    notifyListeners();

    try {
      if (query.isEmpty) {
        // Fetch all restaurants if query is empty
        final restaurants = await _apiService.getRestaurantList();
        _state = Success(restaurants);
      } else {
        final restaurants = await _apiService.searchRestaurant(query);
        _state = Success(restaurants);
      }
    } catch (e) {
      _state = Error(e.toString());
    }
    notifyListeners();
  }

  void clear() {
    _query = '';
    searchRestaurants(''); // Load all restaurants instead of clearing
  }

}
