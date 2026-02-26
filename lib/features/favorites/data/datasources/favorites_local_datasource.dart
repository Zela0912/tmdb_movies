import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tmdb_movies/core/constants/app_constants.dart';
import 'package:tmdb_movies/core/errors/exceptions.dart';
import 'package:tmdb_movies/features/movies/data/models/movie_model.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie.dart';

abstract class FavoritesLocalDatasource {
  Future<List<Movie>> getFavorites();
  Future<void> addFavorite(Movie movie);
  Future<void> removeFavorite(int movieId);
  Future<bool> isFavorite(int movieId);
}

class FavoritesLocalDatasourceImpl implements FavoritesLocalDatasource {
  FavoritesLocalDatasourceImpl() {
    _box = Hive.box(AppConstants.favoritesBoxName);
  }

  late final Box _box;

  List<Movie> _getMoviesFromBox() {
  final data = _box.get(AppConstants.favoritesKey);
  if (data == null) return [];
  final List<dynamic> jsonList = json.decode(data as String);
  return jsonList
      .map<Movie>((e) => MovieModel.fromJson(e as Map<String, dynamic>))
      .toList();
}
  Future<void> _saveMoviesToBox(List<Movie> movies) async {
    final jsonList = movies.map((m) {
      return {
        'id': m.id,
        'title': m.title,
        'overview': m.overview,
        'poster_path': m.posterPath,
        'release_date': m.releaseDate,
        'vote_average': m.voteAverage,
      };
    }).toList();
    await _box.put(AppConstants.favoritesKey, json.encode(jsonList));
  }

  @override
  Future<List<Movie>> getFavorites() async {
    try {
      return _getMoviesFromBox();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> addFavorite(Movie movie) async {
    try {
      final movies = _getMoviesFromBox();
      if (!movies.any((m) => m.id == movie.id)) {
        movies.add(movie);
        await _saveMoviesToBox(movies);
      }
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> removeFavorite(int movieId) async {
    try {
      final movies = _getMoviesFromBox();
      movies.removeWhere((m) => m.id == movieId);
      await _saveMoviesToBox(movies);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    try {
      final movies = _getMoviesFromBox();
      return movies.any((m) => m.id == movieId);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}