import 'package:tmdb_movies/features/favorites/domain/repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  const RemoveFavoriteUseCase({required this.repository});

  final FavoritesRepository repository;

  Future<void> call(int movieId) {
    return repository.removeFavorite(movieId);
  }
}
