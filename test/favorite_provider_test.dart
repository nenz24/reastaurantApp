import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission1/models/restaurant.dart';
import 'package:submission1/providers/favorite_provider.dart';
import 'package:submission1/services/database_helper.dart';

@GenerateMocks([DatabaseHelper])
import 'favorite_provider_test.mocks.dart';

void main() {
  late FavoriteProvider provider;
  late MockDatabaseHelper mockDb;

  final testRestaurant = Restaurant(
    id: '1',
    name: 'Test',
    description: 'Desc',
    pictureId: 'pic',
    city: 'City',
    rating: 4.5,
  );

  setUp(() {
    mockDb = MockDatabaseHelper();
    // Default mock behavior for loading favorites
    when(mockDb.getFavorites()).thenAnswer((_) async => []);
  });

  group('FavoriteProvider', () {
    test('initial favorites list should be empty', () async {
      provider = FavoriteProvider(databaseHelper: mockDb);
      // Wait for loadFavorites to complete (it's called in constructor)
      await Future.delayed(Duration.zero);
      expect(provider.favorites, isEmpty);
    });

    test('should add restaurant to favorites', () async {
      // Initially empty
      var callCount = 0;
      when(mockDb.getFavorites()).thenAnswer((_) async {
        if (callCount == 0) {
          callCount++;
          return [];
        } else {
          return [testRestaurant];
        }
      });
      when(mockDb.insertFavorite(testRestaurant)).thenAnswer((_) async {});

      provider = FavoriteProvider(databaseHelper: mockDb);
      await Future.delayed(Duration.zero); // initial load (callCount 0 -> [])

      await provider.toggleFavorite(
        testRestaurant,
      ); // calls insert, then load (callCount 1 -> [item])

      verify(mockDb.insertFavorite(testRestaurant)).called(1);
      expect(provider.favorites, contains(testRestaurant));
    });

    test('should remove restaurant from favorites', () async {
      // simulate already favorite
      when(mockDb.getFavorites()).thenAnswer((_) async => [testRestaurant]);
      when(mockDb.removeFavorite('1')).thenAnswer((_) async {});

      provider = FavoriteProvider(databaseHelper: mockDb);
      await Future.delayed(Duration.zero); // wait for initial load

      // Now mocking favorites to be empty after removal
      when(mockDb.getFavorites()).thenAnswer((_) async => []);

      await provider.toggleFavorite(testRestaurant);

      verify(mockDb.removeFavorite('1')).called(1);
      expect(provider.favorites, isEmpty);
    });
  });
}
