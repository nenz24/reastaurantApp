import 'package:flutter/material.dart';
import '../models/api_state.dart';
import '../models/restaurant.dart';
import '../services/restaurant_api_service.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantApiService _apiService = RestaurantApiService();
  
  ApiState<List<Restaurant>> _state = const Loading();
  ApiState<List<Restaurant>> get state => _state;

  Future<void> fetchRestaurants() async {
    _state = const Loading();
    notifyListeners();

    try {
      final restaurants = await _apiService.getRestaurantList();
      _state = Success(restaurants);
    } catch (e) {
      _state = Error(e.toString());
    }
    notifyListeners();
  }
}
