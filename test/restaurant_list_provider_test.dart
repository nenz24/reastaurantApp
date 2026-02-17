import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission1/models/api_state.dart';
import 'package:submission1/models/restaurant.dart';
import 'package:submission1/providers/restaurant_list_provider.dart';
import 'package:submission1/services/restaurant_api_service.dart';

@GenerateMocks([RestaurantApiService])
import 'restaurant_list_provider_test.mocks.dart';

void main() {
  late RestaurantListProvider provider;
  late MockRestaurantApiService mockApiService;

  setUp(() {
    mockApiService = MockRestaurantApiService();
    provider = RestaurantListProvider(apiService: mockApiService);
  });

  group('RestaurantListProvider', () {
    test('initial state should be Loading', () {
      expect(provider.state, isA<Loading<List<Restaurant>>>());
    });

    test('should return restaurant list when API call is successful', () async {
      final mockRestaurants = [
        Restaurant(
          id: '1',
          name: 'Test Restaurant',
          description: 'A test restaurant',
          pictureId: 'pic1',
          city: 'Test City',
          rating: 4.5,
        ),
        Restaurant(
          id: '2',
          name: 'Another Restaurant',
          description: 'Another test restaurant',
          pictureId: 'pic2',
          city: 'Another City',
          rating: 4.0,
        ),
      ];

      when(
        mockApiService.getRestaurantList(),
      ).thenAnswer((_) async => mockRestaurants);

      await provider.fetchRestaurants();

      expect(provider.state, isA<Success<List<Restaurant>>>());
      final state = provider.state as Success<List<Restaurant>>;
      expect(state.data.length, 2);
      expect(state.data[0].name, 'Test Restaurant');
      expect(state.data[1].name, 'Another Restaurant');
    });

    test('should return error when API call fails', () async {
      when(
        mockApiService.getRestaurantList(),
      ).thenThrow(Exception('Network error'));

      await provider.fetchRestaurants();

      expect(provider.state, isA<Error<List<Restaurant>>>());
      final state = provider.state as Error<List<Restaurant>>;
      expect(state.message, 'Failed to load restaurants');
    });
  });
}
