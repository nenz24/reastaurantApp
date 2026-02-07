import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/api_state.dart';
import '../providers/restaurant_list_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/error_view.dart';
import 'restaurant_detail_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<RestaurantListProvider>().fetchRestaurants();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom Cupertino-style Header
            SliverToBoxAdapter(child: const HomeHeader()),
            // List Content
            Consumer<RestaurantListProvider>(
              builder: (context, provider, child) {
                final state = provider.state;

                return switch (state) {
                  Loading() => const SliverFillRemaining(
                    child: Center(child: CupertinoActivityIndicator()),
                  ),
                  Success(data: final restaurants) =>
                    restaurants.isEmpty
                        ? SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'No restaurants found',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final restaurant = restaurants[index];
                              return RestaurantCard(
                                restaurant: restaurant,
                                heroTag: 'list-${restaurant.id}',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantDetailScreen(
                                            restaurantId: restaurant.id,
                                            heroTag: 'list-${restaurant.id}',
                                          ),
                                    ),
                                  );
                                },
                              );
                            }, childCount: restaurants.length),
                          ),
                  Error(message: final message) => SliverFillRemaining(
                    child: ErrorView(
                      message: message,
                      onRetry: () => provider.fetchRestaurants(),
                    ),
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
