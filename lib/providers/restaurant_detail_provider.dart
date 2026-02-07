import 'package:flutter/material.dart';
import '../models/api_state.dart';
import '../models/restaurant.dart';
import '../services/restaurant_api_service.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantApiService _apiService = RestaurantApiService();
  
  ApiState<RestaurantDetail> _state = const Loading();
  ApiState<RestaurantDetail> get state => _state;

  bool _isSubmittingReview = false;
  bool get isSubmittingReview => _isSubmittingReview;

  Future<void> fetchRestaurantDetail(String id) async {
    _state = const Loading();
    notifyListeners();

    try {
      final restaurant = await _apiService.getRestaurantDetail(id);
      _state = Success(restaurant);
    } catch (e) {
      _state = Error(e.toString());
    }
    notifyListeners();
  }

  Future<bool> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    _isSubmittingReview = true;
    notifyListeners();

    try {
      final success = await _apiService.addReview(
        id: id,
        name: name,
        review: review,
      );
      
      if (success) {
        // Refresh detail to get updated reviews
        await fetchRestaurantDetail(id);
      }
      
      _isSubmittingReview = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isSubmittingReview = false;
      notifyListeners();
      return false;
    }
  }
}
