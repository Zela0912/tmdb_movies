import 'package:fpdart/fpdart.dart';
import 'package:tmdb_movies/core/errors/failures.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';
import 'package:tmdb_movies/features/movies/domain/repositories/movie_repository.dart';

class GetPopularMoviesUseCase {
  const GetPopularMoviesUseCase({required this.repository});

  final MovieRepository repository;

  Future<Either<AppFailure, List<Movie>>> call(int page) {
    return repository.getPopularMovies(page);
  }
}
