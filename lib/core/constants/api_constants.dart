import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['TMDB_BASE_URL'] ?? '';
  static String get imageBaseUrl => dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';

  static String posterUrl(String posterPath, {String size = 'w500'}) {
    return '$imageBaseUrl/$size$posterPath';
  }

  static const String popularMovies = '/movie/popular';
  static String movieDetail(int id) => '/movie/$id';
}