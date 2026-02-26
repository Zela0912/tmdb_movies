import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movies/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:tmdb_movies/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:tmdb_movies/features/favorites/domain/usecases/add_favorite_usecase.dart';
import 'package:tmdb_movies/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:tmdb_movies/features/favorites/domain/usecases/remove_favorite_usecase.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie_detail.dart';

final favoritesLocalDatasourceProvider = Provider<FavoritesLocalDatasource>((ref) {
  return FavoritesLocalDatasourceImpl();
});

final favoritesRepositoryProvider = Provider<FavoritesRepositoryImpl>((ref) {
  return FavoritesRepositoryImpl(
    localDatasource: ref.watch(favoritesLocalDatasourceProvider),
  );
});

final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>((ref) {
  return GetFavoritesUseCase(repository: ref.watch(favoritesRepositoryProvider));
});

final addFavoriteUseCaseProvider = Provider<AddFavoriteUseCase>((ref) {
  return AddFavoriteUseCase(repository: ref.watch(favoritesRepositoryProvider));
});

final removeFavoriteUseCaseProvider = Provider<RemoveFavoriteUseCase>((ref) {
  return RemoveFavoriteUseCase(repository: ref.watch(favoritesRepositoryProvider));
});

class FavoritesState {
  const FavoritesState({this.favorites = const []});

  final List<Movie> favorites;

  FavoritesState copyWith({List<Movie>? favorites}) {
    return FavoritesState(favorites: favorites ?? this.favorites);
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier(
    this._getFavorites,
    this._addFavorite,
    this._removeFavorite,
  ) : super(const FavoritesState()) {
    loadFavorites();
  }

  final GetFavoritesUseCase _getFavorites;
  final AddFavoriteUseCase _addFavorite;
  final RemoveFavoriteUseCase _removeFavorite;

  Future<void> loadFavorites() async {
    try {
      final favorites = await _getFavorites();
      state = state.copyWith(favorites: favorites);
    } catch (e) {
      debugPrint('loadFavorites error: $e');
    }
  }

  Future<bool> toggleFavorite(Movie movie) async {
    try {
      final isFav = state.favorites.any((m) => m.id == movie.id);
      if (isFav) {
        await _removeFavorite(movie.id);
        state = state.copyWith(
          favorites: state.favorites.where((m) => m.id != movie.id).toList(),
        );
      } else {
        await _addFavorite(movie);
        state = state.copyWith(favorites: [...state.favorites, movie]);
      }
      return true;
    } catch (e) {
      debugPrint('toggleFavorite error: $e');
      return false;
    }
  }

  Future<bool> toggleFavoriteFromDetail(MovieDetail movieDetail) async {
    final movie = Movie(
      id: movieDetail.id,
      title: movieDetail.title,
      overview: movieDetail.overview,
      posterPath: movieDetail.posterPath,
      releaseDate: movieDetail.releaseDate,
      voteAverage: movieDetail.voteAverage,
    );
    return toggleFavorite(movie);
  }

  Future<void> removeFavorite(int movieId) async {
    try {
      await _removeFavorite(movieId);
      state = state.copyWith(
        favorites: state.favorites.where((m) => m.id != movieId).toList(),
      );
    } catch (e) {
      debugPrint('removeFavorite error: $e');
    }
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(
    ref.watch(getFavoritesUseCaseProvider),
    ref.watch(addFavoriteUseCaseProvider),
    ref.watch(removeFavoriteUseCaseProvider),
  );
});

final isFavoriteProvider = Provider.family<bool, int>((ref, movieId) {
  final state = ref.watch(favoritesProvider);
  return state.favorites.any((m) => m.id == movieId);
});