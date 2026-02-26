import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie_detail.dart';

abstract class FavoritesRepository {
  Future<List<Movie>> getFavorites();
  Future<void> addFavorite(Movie movie);
  Future<void> removeFavorite(int movieId);
  Future<bool> isFavorite(int movieId);
}