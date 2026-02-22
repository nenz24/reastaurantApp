import 'package:flutter_test/flutter_test.dart';
import 'package:submission1/models/api_state.dart';
import 'package:submission1/models/restaurant.dart';
import 'package:submission1/providers/search_provider.dart';

void main() {
  group('SearchProvider Test', () {
    test('should have Loading as initial state', () {
      final provider = SearchProvider();
      expect(provider.state, isA<Loading>());
    });

    test('should have empty query initially', () {
      final provider = SearchProvider();
      expect(provider.query, '');
    });
  });

  group('Restaurant Model Test - RestaurantDetail', () {
    test('should parse RestaurantDetail from JSON correctly', () {
      final json = {
        'id': 'rqdv5juczeskfw1e867',
        'name': 'Melting Pot',
        'description': 'Lorem ipsum dolor sit amet',
        'city': 'Medan',
        'address': 'Jln. Pandeglang no 19',
        'pictureId': '14',
        'categories': [
          {'name': 'Italia'},
          {'name': 'Modern'},
        ],
        'menus': {
          'foods': [
            {'name': 'Paket rosemary'},
          ],
          'drinks': [
            {'name': 'Es teh'},
          ],
        },
        'rating': 4.2,
        'customerReviews': [
          {
            'name': 'Ahmad',
            'review': 'Tidak rekomendasi',
            'date': '13 November 2019',
          },
        ],
      };

      final detail = RestaurantDetail.fromJson(json);

      expect(detail.id, 'rqdv5juczeskfw1e867');
      expect(detail.name, 'Melting Pot');
      expect(detail.description, 'Lorem ipsum dolor sit amet');
      expect(detail.city, 'Medan');
      expect(detail.address, 'Jln. Pandeglang no 19');
      expect(detail.pictureId, '14');
      expect(detail.categories.length, 2);
      expect(detail.categories[0].name, 'Italia');
      expect(detail.menus.foods.length, 1);
      expect(detail.menus.foods[0].name, 'Paket rosemary');
      expect(detail.menus.drinks.length, 1);
      expect(detail.menus.drinks[0].name, 'Es teh');
      expect(detail.rating, 4.2);
      expect(detail.customerReviews.length, 1);
      expect(detail.customerReviews[0].name, 'Ahmad');
    });

    test('should handle empty/null fields gracefully', () {
      final json = <String, dynamic>{};

      final detail = RestaurantDetail.fromJson(json);

      expect(detail.id, '');
      expect(detail.name, '');
      expect(detail.categories, isEmpty);
      expect(detail.customerReviews, isEmpty);
    });
  });
}
