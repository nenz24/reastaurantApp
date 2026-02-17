import 'package:flutter_test/flutter_test.dart';
import 'package:submission1/models/restaurant.dart';

void main() {
  group('Restaurant Model Test', () {
    test('should parse Restaurant from JSON correctly', () {
      final json = {
        'id': 'rqdv5juczeskfw1e867',
        'name': 'Melting Pot',
        'description': 'Lorem ipsum dolor sit amet',
        'pictureId': '14',
        'city': 'Medan',
        'rating': 4.2,
      };

      final restaurant = Restaurant.fromJson(json);

      expect(restaurant.id, 'rqdv5juczeskfw1e867');
      expect(restaurant.name, 'Melting Pot');
      expect(restaurant.description, 'Lorem ipsum dolor sit amet');
      expect(restaurant.pictureId, '14');
      expect(restaurant.city, 'Medan');
      expect(restaurant.rating, 4.2);
      expect(
        restaurant.imageUrl,
        'https://restaurant-api.dicoding.dev/images/medium/14',
      );
    });
  });
}
