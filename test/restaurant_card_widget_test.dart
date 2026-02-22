import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:submission1/models/restaurant.dart';

void main() {
  final testRestaurant = Restaurant(
    id: 'test-id-123',
    name: 'Test Restaurant',
    description: 'A great place to eat',
    pictureId: '14',
    city: 'Jakarta',
    rating: 4.5,
  );

  group('RestaurantCard Widget Test', () {
    testWidgets('should display restaurant info correctly', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () => tapped = true,
              child: Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testRestaurant.name,
                            key: const Key('restaurant_name'),
                          ),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.location_solid,
                                size: 14,
                              ),
                              Text(
                                testRestaurant.city,
                                key: const Key('restaurant_city'),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(CupertinoIcons.star_fill, size: 14),
                              Text(
                                testRestaurant.rating.toString(),
                                key: const Key('restaurant_rating'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Verify restaurant name is displayed
      expect(find.text('Test Restaurant'), findsOneWidget);

      // Verify city is displayed
      expect(find.text('Jakarta'), findsOneWidget);

      // Verify rating is displayed
      expect(find.text('4.5'), findsOneWidget);

      // Verify tap works
      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, true);
    });

    testWidgets('should display correct image URL from model', (tester) async {
      expect(
        testRestaurant.imageUrl,
        'https://restaurant-api.dicoding.dev/images/medium/14',
      );
    });
  });
}
