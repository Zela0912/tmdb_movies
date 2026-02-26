import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movies/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:tmdb_movies/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';
import 'package:tmdb_movies/features/movies/domain/usecases/get_popular_movies_usecase.dart';
import 'package:tmdb_movies/core/network/dio_client.dart';

// Dependency providers — svaki sloj dobije što mu treba
final movieRemoteDatasourceProvider = Provider<MovieRemoteDatasource>((ref) {
  return MovieRemoteDatasourceImpl(dioClient: DioClient.instance);
});

final movieRepositoryProvider = Provider<MovieRepositoryImpl>((ref) {
  return MovieRepositoryImpl(
    remoteDatasource: ref.watch(movieRemoteDatasourceProvider),
  );
});

final getPopularMoviesUseCaseProvider = Provider<GetPopularMoviesUseCase>((ref) {
  return GetPopularMoviesUseCase(
    repository: ref.watch(movieRepositoryProvider),
  );
});

// State klasa za paginaciju
class MoviesState {
  const MoviesState({
    this.movies = const [],
    this.currentPage = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.error,
  });

  final List<Movie> movies;
  final int currentPage;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String? error;

  MoviesState copyWith({
    List<Movie>? movies,
    int? currentPage,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    String? error,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: error,
    );
  }
}

// Notifier — upravlja stanjem liste filmova
class MoviesNotifier extends StateNotifier<MoviesState> {
  MoviesNotifier(this._getPopularMovies) : super(const MoviesState()) {
    fetchMovies();
  }

  final GetPopularMoviesUseCase _getPopularMovies;

  Future<void> fetchMovies() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _getPopularMovies(1);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (movies) => state = state.copyWith(
        isLoading: false,
        movies: movies,
        currentPage: 1,
        hasReachedEnd: false,
      ),
    );
  }

  Future<void> fetchMoreMovies() async {
    if (state.isLoadingMore || state.hasReachedEnd) return;

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.currentPage + 1;
    final result = await _getPopularMovies(nextPage);

    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        error: failure.message,
      ),
      (newMovies) {
        if (newMovies.isEmpty) {
          state = state.copyWith(
            isLoadingMore: false,
            hasReachedEnd: true,
          );
        } else {
          state = state.copyWith(
            isLoadingMore: false,
            movies: [...state.movies, ...newMovies],
            currentPage: nextPage,
          );
        }
      },
    );
  }
}

final moviesProvider = StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
  return MoviesNotifier(ref.watch(getPopularMoviesUseCaseProvider));
});
