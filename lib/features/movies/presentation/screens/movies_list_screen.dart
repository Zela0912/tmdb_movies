import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movies/features/movies/presentation/providers/movies_provider.dart';
import 'package:tmdb_movies/features/movies/presentation/widgets/movie_card.dart';
import 'package:tmdb_movies/features/movies/presentation/widgets/movie_list_item_shimmer.dart';
import 'package:tmdb_movies/features/movies/presentation/widgets/pagination_loader.dart';
import 'package:tmdb_movies/shared/widgets/error_view.dart';

class MoviesListScreen extends ConsumerStatefulWidget {
  const MoviesListScreen({super.key});

  @override
  ConsumerState<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends ConsumerState<MoviesListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      ref.read(moviesProvider.notifier).fetchMoreMovies();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll * 0.9;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(moviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(MoviesState state) {
    // Initial loading
    if (state.isLoading) {
      return ListView.builder(
        itemCount: 8,
        itemBuilder: (_, __) => const MovieListItemShimmer(),
      );
    }

    // Error state — no movies loaded yet
    if (state.error != null && state.movies.isEmpty) {
      return ErrorView(
        message: state.error!,
        onRetry: () => ref.read(moviesProvider.notifier).fetchMovies(),
      );
    }

    // Movies list
    return RefreshIndicator(
      onRefresh: () => ref.read(moviesProvider.notifier).fetchMovies(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.movies.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.movies.length) {
            return const PaginationLoader();
          }
          return MovieCard(movie: state.movies[index]);
        },
      ),
    );
  }
}
