import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:movie_search_app_001/core/error/exceptions.dart';
import 'package:movie_search_app_001/data/models/movie_model.dart';

import 'movie_local_datasource.dart';

const String _favouritesKey = 'favourite_movies';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  MovieLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<List<MovieModel>> getFavouriteMovies() async {
    final json = _prefs.getString(_favouritesKey);
    if (json == null || json.isEmpty) return [];

    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .cast<Map<String, dynamic>>()
          .map((e) => MovieModel.fromJson(e))
          .toList();
    } catch (_) {
      throw CacheException('Failed to read favourites');
    }
  }

  @override
  Future<void> addFavourite(MovieModel movie) async {
    final list = await getFavouriteMovies();
    if (list.any((m) => m.imdbID == movie.imdbID)) return;

    list.add(movie);
    await _save(list);
  }

  @override
  Future<void> removeFavourite(String imdbID) async {
    final list = await getFavouriteMovies();
    list.removeWhere((m) => m.imdbID == imdbID);
    await _save(list);
  }

  @override
  Future<bool> isFavourite(String imdbID) async {
    final list = await getFavouriteMovies();
    return list.any((m) => m.imdbID == imdbID);
  }

  Future<void> _save(List<MovieModel> list) async {
    final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
    final ok = await _prefs.setString(_favouritesKey, encoded);
    if (!ok) throw CacheException('Failed to save favourites');
  }
}
