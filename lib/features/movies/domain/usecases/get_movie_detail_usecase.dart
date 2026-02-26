import 'package:fpdart/fpdart.dart';
import 'package:tmdb_movies/core/errors/failures.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:tmdb_movies/features/movies/domain/repositories/movie_repository.dart';

class GetMovieDetailUseCase {
  const GetMovieDetailUseCase({required this.repository});

  final MovieRepository repository;

  Future<Either<AppFailure, MovieDetail>> call(int id) {
    return repository.getMovieDetail(id);
  }
}
