import 'package:tmdb_movies/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';

class AddFavoriteUseCase {
  const AddFavoriteUseCase({required this.repository});

  final FavoritesRepository repository;

  Future<void> call(Movie movie) {
    return repository.addFavorite(movie);
  }
}