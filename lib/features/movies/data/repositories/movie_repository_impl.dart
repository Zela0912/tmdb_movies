import 'package:fpdart/fpdart.dart';
import 'package:tmdb_movies/core/errors/exceptions.dart';
import 'package:tmdb_movies/core/errors/failures.dart';
import 'package:tmdb_movies/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:tmdb_movies/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl({required this.remoteDatasource});

  final MovieRemoteDatasource remoteDatasource;

  @override
  Future<Either<AppFailure, List<Movie>>> getPopularMovies(int page) async {
    try {
      final movies = await remoteDatasource.getPopularMovies(page);
      return Right(movies);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NotFoundException {
      return Left(NotFoundFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, MovieDetail>> getMovieDetail(int id) async {
    try {
      final movie = await remoteDatasource.getMovieDetail(id);
      return Right(movie);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NotFoundException {
      return Left(NotFoundFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
