import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_movies/core/constants/api_constants.dart';
import 'package:tmdb_movies/core/constants/app_constants.dart';
import 'package:tmdb_movies/core/router/app_router.dart';
import 'package:tmdb_movies/core/theme/app_colors.dart';
import 'package:tmdb_movies/core/utils/date_formatter.dart';
import 'package:tmdb_movies/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';
import 'package:tmdb_movies/shared/widgets/rating_badge.dart';

class MovieCard extends ConsumerWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(movie.id));

    return GestureDetector(
      onTap: () => context.push(AppRouter.movieDetailPath(movie.id)),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.verticalPadding / 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'poster_${movie.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadius),
                  bottomLeft: Radius.circular(AppConstants.borderRadius),
                ),
                child: CachedNetworkImage(
                  imageUrl: movie.posterPath != null
                      ? ApiConstants.posterUrl(
                          movie.posterPath!,
                          size: AppConstants.thumbnailPosterSize,
                        )
                      : '',
                  width: 95,
                  height: 140,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 95,
                    height: 140,
                    color: AppColors.surface,
                    child: const Icon(Icons.movie, color: AppColors.textHint),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 95,
                    height: 140,
                    color: AppColors.surface,
                    child: const Icon(Icons.broken_image,
                        color: AppColors.textHint),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormatter.formatYear(movie.releaseDate),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    RatingBadge(rating: movie.voteAverage),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () async {
                  final success = await ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(movie);
                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not update favorites. Try again.'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite
                      ? AppColors.favoriteActive
                      : AppColors.favoriteInactive,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
