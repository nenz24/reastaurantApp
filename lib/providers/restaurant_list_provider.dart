import 'package:flutter/material.dart';
import 'dart:io';
import '../models/api_state.dart';
import '../models/restaurant.dart';
import '../services/restaurant_api_service.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantApiService _apiService;

  RestaurantListProvider({RestaurantApiService? apiService})
    : _apiService = apiService ?? RestaurantApiService();

  ApiState<List<Restaurant>> _state = const Loading();
  ApiState<List<Restaurant>> get state => _state;

  Future<void> fetchRestaurants() async {
    _state = const Loading();
    notifyListeners();

    try {
      final restaurants = await _apiService.getRestaurantList();
      _state = Success(restaurants);
    } on SocketException {
      _state = const Error('No Internet connection');
    } catch (e) {
      _state = const Error('Failed to load restaurants');
    }
    notifyListeners();
  }
}
