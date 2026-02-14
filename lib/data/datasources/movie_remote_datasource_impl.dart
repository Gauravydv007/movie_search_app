import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:movie_search_app_001/core/constants/api_constants.dart';
import 'package:movie_search_app_001/core/error/exceptions.dart';
import 'package:movie_search_app_001/data/models/movie_detail_model.dart';
import 'package:movie_search_app_001/data/models/movie_model.dart';

import 'movie_remote_datasource.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  MovieRemoteDataSourceImpl(this._client);

  final http.Client _client;

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final uri = Uri.parse(ApiConstants.baseUrl).replace(
      queryParameters: {
        'apikey': ApiConstants.apiKey,
        's': query.trim(),
      },
    );
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw ServerException('Search failed: ${response.statusCode}');
    }

    final map = jsonDecode(response.body) as Map<String, dynamic>;
    if (map['Response'] == 'False') {
      final error = map['Error'] as String? ?? 'Unknown error';
      throw ServerException(error);
    }

    final list = map['Search'] as List<dynamic>?;
    if (list == null || list.isEmpty) {
      return [];
    }

    return list
        .cast<Map<String, dynamic>>()
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }

  @override
  Future<MovieDetailModel> getMovieById(String imdbID) async {
    final uri = Uri.parse(ApiConstants.baseUrl).replace(
      queryParameters: {
        'apikey': ApiConstants.apiKey,
        'i': imdbID,
      },
    );
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw ServerException('Get movie failed: ${response.statusCode}');
    }

    final map = jsonDecode(response.body) as Map<String, dynamic>;
    if (map['Response'] == 'False') {
      final error = map['Error'] as String? ?? 'Movie not found';
      throw ServerException(error);
    }

    return MovieDetailModel.fromJson(map);
  }
}
