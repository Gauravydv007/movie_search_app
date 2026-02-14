import 'package:movie_search_app_001/data/models/movie_detail_model.dart';
import 'package:movie_search_app_001/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> searchMovies(String query);
  Future<MovieDetailModel> getMovieById(String imdbID);
}
