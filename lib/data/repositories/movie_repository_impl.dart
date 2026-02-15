import 'package:movie_search_app_001/core/error/exceptions.dart';
import 'package:movie_search_app_001/core/network/network_info.dart';
import 'package:movie_search_app_001/data/datasources/movie_local_datasource.dart';
import 'package:movie_search_app_001/data/datasources/movie_remote_datasource.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/domain/entities/movie_detail.dart';
import 'package:movie_search_app_001/data/models/movie_model.dart';
import 'package:movie_search_app_001/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({
    required MovieRemoteDataSource remote,
    required MovieLocalDataSource local,
    required NetworkInfo networkInfo,
  })  : _remote = remote,
        _local = local,
        _networkInfo = networkInfo;

  final MovieRemoteDataSource _remote;
  final MovieLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];
    final connected = await _networkInfo.isConnected;
    if (!connected) {
      throw NetworkException('No internet connection');
    }
    try {
      final list = await _remote.searchMovies(query);
      return list.map((m) => m.toEntity()).toList();
    } on ServerException catch (e) {
      rethrow;
      
    }
  }

  @override
  Future<MovieDetail> getMovieById(String imdbID) async {
    final connected = await _networkInfo.isConnected;
    if (!connected) {
      throw  NetworkException('No internet connection');
    }
    try {
      final model = await _remote.getMovieById(imdbID);
      return model.toEntity();
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<List<String>> getFavouriteIds() async {
    final list = await getFavourites();
    return list.map((m) => m.imdbID).toList();
  }

  @override
  Future<List<Movie>> getFavourites() async {
    try {
      final list = await _local.getFavouriteMovies();
      return list.map((m) => m.toEntity()).toList();
    } on CacheException {
      rethrow;
    }
  }

  @override
  Future<void> addFavourite(Movie movie) async {
    try {
      final model = _movieToModel(movie);
      await _local.addFavourite(model);
    } on CacheException {
      rethrow;
    }
  }

  @override
  Future<void> removeFavourite(String imdbID) async {
    try {
      await _local.removeFavourite(imdbID);
    } on CacheException {
      rethrow;
    }
  }

  @override
  Future<bool> isFavourite(String imdbID) async {
    try {
      return _local.isFavourite(imdbID);
    } on CacheException {
      return false;
    }
  }

  MovieModel _movieToModel(Movie movie) {
    return MovieModel(
      imdbID: movie.imdbID,
      title: movie.title,
      year: movie.year,
      type: movie.type,
      poster: movie.poster,
    );
  }
}
