import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/api_state.dart';
import '../providers/search_provider.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/error_view.dart';
import 'restaurant_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<SearchProvider>().searchRestaurants('');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (query == _searchController.text && mounted) {
        context.read<SearchProvider>().searchRestaurants(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Search'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context).disabledColor,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                final state = provider.state;

                return switch (state) {
                  Loading() => const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                  Success(data: final restaurants) =>
                    restaurants.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.search,
                                  size: 64,
                                  color: Theme.of(context).disabledColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No restaurants found',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context).disabledColor,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: restaurants.length,
                            padding: const EdgeInsets.only(bottom: 20),
                            itemBuilder: (context, index) {
                              final restaurant = restaurants[index];
                              return RestaurantCard(
                                restaurant: restaurant,
                                heroTag: 'search-${restaurant.id}',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantDetailScreen(
                                            restaurantId: restaurant.id,
                                            heroTag: 'search-${restaurant.id}',
                                          ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  Error(message: final message) => ErrorView(
                    message: message,
                    onRetry: () => provider.searchRestaurants(provider.query),
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
