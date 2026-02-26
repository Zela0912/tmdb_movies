import 'package:fpdart/fpdart.dart';
import 'package:tmdb_movies/core/errors/failures.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie_detail.dart';

abstract class MovieRepository {
  Future<Either<AppFailure, List<Movie>>> getPopularMovies(int page);
  Future<Either<AppFailure, MovieDetail>> getMovieDetail(int id);
}
