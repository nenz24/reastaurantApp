import 'package:flutter/material.dart';
import 'dart:io';
import '../models/api_state.dart';
import '../models/restaurant.dart';
import '../services/restaurant_api_service.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantApiService _apiService = RestaurantApiService();

  ApiState<RestaurantDetail> _state = const Loading();
  ApiState<RestaurantDetail> get state => _state;

  bool _isSubmittingReview = false;
  bool get isSubmittingReview => _isSubmittingReview;

  String? _reviewError;
  String? get reviewError => _reviewError;

  Future<void> fetchRestaurantDetail(String id) async {
    _state = const Loading();
    notifyListeners();

    try {
      final restaurant = await _apiService.getRestaurantDetail(id);
      _state = Success(restaurant);
    } on SocketException {
      _state = const Error('No Internet connection');
    } catch (e) {
      _state = const Error('Failed to load restaurant details');
    }
    notifyListeners();
  }

  Future<bool> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    _isSubmittingReview = true;
    _reviewError = null;
    notifyListeners();

    try {
      final success = await _apiService.addReview(
        id: id,
        name: name,
        review: review,
      );

      if (success) {
        await fetchRestaurantDetail(id);
      } else {
        _reviewError = 'Failed to submit review. Please try again.';
      }

      _isSubmittingReview = false;
      notifyListeners();
      return success;
    } on SocketException {
      _isSubmittingReview = false;
      _reviewError = 'No Internet connection';
      notifyListeners();
      return false;
    } catch (e) {
      _isSubmittingReview = false;
      _reviewError = 'Failed to submit review';
      notifyListeners();
      return false;
    }
  }
}
