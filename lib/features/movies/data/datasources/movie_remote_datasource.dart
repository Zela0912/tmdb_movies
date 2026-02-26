import 'package:tmdb_movies/core/constants/api_constants.dart';
import 'package:tmdb_movies/core/network/dio_client.dart';
import 'package:tmdb_movies/features/movies/data/models/movie_detail_model.dart';
import 'package:tmdb_movies/features/movies/data/models/movie_model.dart';

abstract class MovieRemoteDatasource {
  Future<List<MovieModel>> getPopularMovies(int page);
  Future<MovieDetailModel> getMovieDetail(int id);
}

class MovieRemoteDatasourceImpl implements MovieRemoteDatasource {
  const MovieRemoteDatasourceImpl({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<List<MovieModel>> getPopularMovies(int page) async {
    final response = await dioClient.get(
      ApiConstants.popularMovies,
      queryParameters: {'page': page},
    );

    final results = response['results'] as List<dynamic>;
    return results
        .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MovieDetailModel> getMovieDetail(int id) async {
    final response = await dioClient.get(ApiConstants.movieDetail(id));
    return MovieDetailModel.fromJson(response as Map<String, dynamic>);
  }
}
