import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'My Favorites',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            Consumer<FavoriteProvider>(
              builder: (context, provider, child) {
                final favorites = provider.favorites;

                if (favorites.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.heart,
                            size: 64,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No favorites yet',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final restaurant = favorites[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        heroTag: 'favorite-${restaurant.id}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailScreen(
                                restaurantId: restaurant.id,
                                heroTag: 'favorite-${restaurant.id}',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: favorites.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
