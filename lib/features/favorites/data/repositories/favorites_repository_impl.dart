import 'package:tmdb_movies/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:tmdb_movies/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl({required this.localDatasource});

  final FavoritesLocalDatasource localDatasource;

  @override
  Future<List<Movie>> getFavorites() async {
    return await localDatasource.getFavorites();
  }

  @override
  Future<void> addFavorite(Movie movie) async {
    await localDatasource.addFavorite(movie);
  }

  @override
  Future<void> removeFavorite(int movieId) async {
    await localDatasource.removeFavorite(movieId);
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    return await localDatasource.isFavorite(movieId);
  }
}