import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../providers/favorite_provider.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  final String? heroTag;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: heroTag ?? 'restaurant-${restaurant.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: restaurant.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const CupertinoActivityIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        size: 14,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.city,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.star_fill,
                        size: 14,
                        color: Color(0xFFFFAB40),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                final isFav = favoriteProvider.isFavorite(restaurant.id);
                return IconButton(
                  onPressed: () {
                    favoriteProvider.toggleFavorite(restaurant);
                  },
                  icon: Icon(
                    isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: isFav
                        ? Colors.redAccent
                        : Theme.of(context).disabledColor,
                    size: 22,
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
