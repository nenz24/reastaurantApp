import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class RestaurantApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> getRestaurantList() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/list'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> restaurantsJson = data['restaurants'] ?? [];

        return restaurantsJson
            .map((json) => Restaurant.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to load restaurants. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading restaurants: $e');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, dynamic> restaurantJson = data['restaurant'] ?? {};

        return RestaurantDetail.fromJson(restaurantJson);
      } else {
        throw Exception(
            'Failed to load restaurant detail. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading restaurant detail: $e');
    }
  }

  Future<List<Restaurant>> searchRestaurant(String query) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/search?q=$query'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> restaurantsJson = data['restaurants'] ?? [];

        return restaurantsJson
            .map((json) => Restaurant.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to search restaurants. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching restaurants: $e');
    }
  }

  Future<bool> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'name': name,
          'review': review,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['error'] == false;
      } else {
        throw Exception(
            'Failed to add review. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding review: $e');
    }
  }
}
