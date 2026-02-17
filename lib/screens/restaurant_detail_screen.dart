import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:readmore/readmore.dart';
import 'package:provider/provider.dart';
import '../models/api_state.dart';
import '../providers/restaurant_detail_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/review_card.dart';
import '../widgets/review_form.dart';
import '../widgets/detail_menu_section.dart';
import '../themes/colors.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  final String heroTag;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
    required this.heroTag,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
          widget.restaurantId,
        );
      }
    });
  }

  void _showReviewForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          return ReviewForm(
            isSubmitting: provider.isSubmittingReview,
            errorMessage: provider.reviewError,
            onSubmit: (name, review) async {
              final messenger = ScaffoldMessenger.of(context);
              final success = await provider.addReview(
                id: widget.restaurantId,
                name: name,
                review: review,
              );

              if (mounted && success) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Review submitted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
              return success;
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic restaurant) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: widget.heroTag,
                child: Image.network(
                  restaurant.pictureId.startsWith('http')
                      ? restaurant.pictureId
                      : 'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: Consumer<FavoriteProvider>(
                  builder: (context, favoriteProvider, child) {
                    final isFav = favoriteProvider.isFavorite(restaurant.id);
                    return CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      child: IconButton(
                        icon: Icon(
                          isFav
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: isFav ? Colors.redAccent : Colors.white,
                        ),
                        onPressed: () {
                          favoriteProvider.addFavoriteFromDetail(restaurant);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.rating.toString(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${restaurant.address}, ${restaurant.city}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: restaurant.categories.map<Widget>((category) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Text(
                        category.name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                ReadMoreText(
                  restaurant.description,
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Read more',
                  trimExpandedText: 'Show less',
                  colorClickableText: Theme.of(context).colorScheme.primary,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 32),
                DetailMenuSection(
                  title: 'Foods',
                  items: restaurant.menus.foods,
                  icon: CupertinoIcons.square_stack_3d_up,
                ),
                const SizedBox(height: 24),
                DetailMenuSection(
                  title: 'Drinks',
                  items: restaurant.menus.drinks,
                  icon: CupertinoIcons.drop_fill,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reviews',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showReviewForm(context),
                      icon: const Icon(Icons.add_comment),
                      label: const Text('Add Review'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          final state = provider.state;
          return switch (state) {
            Loading() => const Center(child: CupertinoActivityIndicator()),
            Success(data: final restaurant) => CustomScrollView(
              slivers: [
                _buildHeader(context, restaurant),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final review = restaurant.customerReviews[index];
                      return ReviewCard(review: review);
                    }, childCount: restaurant.customerReviews.length),
                  ),
                ),
              ],
            ),
            Error(message: final message) => Center(
              child: ErrorView(
                message: message,
                onRetry: () =>
                    provider.fetchRestaurantDetail(widget.restaurantId),
              ),
            ),
          };
        },
      ),
    );
  }
}
