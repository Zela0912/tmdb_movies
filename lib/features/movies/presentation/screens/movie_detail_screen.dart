import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movies/core/constants/api_constants.dart';
import 'package:tmdb_movies/core/constants/app_constants.dart';
import 'package:tmdb_movies/core/theme/app_colors.dart';
import 'package:tmdb_movies/core/utils/date_formatter.dart';
import 'package:tmdb_movies/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:tmdb_movies/features/movies/presentation/providers/movie_detail_provider.dart';
import 'package:tmdb_movies/shared/widgets/error_view.dart';
import 'package:tmdb_movies/shared/widgets/loading_indicator.dart';
import 'package:tmdb_movies/shared/widgets/rating_badge.dart';

class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      body: movieAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(movieDetailProvider(movieId)),
        ),
        data: (movie) => _MovieDetailContent(movie: movie),
      ),
    );
  }
}

class _MovieDetailContent extends ConsumerWidget {
  const _MovieDetailContent({required this.movie});

  final MovieDetail movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(movie.id));

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          actions: [
            IconButton(
              onPressed: () async {
                final success = await ref
                    .read(favoritesProvider.notifier)
                    .toggleFavoriteFromDetail(movie);
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
                    : AppColors.textPrimary,
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: movie.posterPath != null
                ? Hero(
                    tag: 'poster_${movie.id}',
                    child: CachedNetworkImage(
                      imageUrl: ApiConstants.posterUrl(
                        movie.posterPath!,
                        size: AppConstants.detailPosterSize,
                      ),
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: AppColors.surface),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.broken_image,
                          color: AppColors.textHint,
                          size: 64,
                        ),
                      ),
                    ),
                  )
                : Container(color: AppColors.surface),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    RatingBadge(rating: movie.voteAverage),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.formatFullDate(movie.releaseDate),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (movie.runtime != null) ...[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.runtime} min',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                if (movie.genres.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres.map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.secondary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          genre,
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview.isEmpty
                      ? 'No overview available.'
                      : movie.overview,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}