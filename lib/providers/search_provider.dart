import 'package:flutter/material.dart';
import 'dart:io';
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
      final List<Restaurant> restaurants;
      if (query.isEmpty) {
        restaurants = await _apiService.getRestaurantList();
      } else {
        restaurants = await _apiService.searchRestaurant(query);
      }
      _state = Success(restaurants);
    } on SocketException {
      _state = const Error('No Internet connection');
    } catch (e) {
      _state = const Error('Failed to search restaurants');
    }
    notifyListeners();
  }

  void clear() {
    _query = '';
    searchRestaurants('');
  }
}
