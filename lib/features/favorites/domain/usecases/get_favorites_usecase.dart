import 'package:tmdb_movies/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';

class GetFavoritesUseCase {
  const GetFavoritesUseCase({required this.repository});

  final FavoritesRepository repository;

  Future<List<Movie>> call() {
    return repository.getFavorites();
  }
}
