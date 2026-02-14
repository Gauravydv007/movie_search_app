import 'package:movie_search_app_001/data/models/movie_model.dart';

/// Local data source for favourite movies (persisted).
abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getFavouriteMovies();
  Future<void> addFavourite(MovieModel movie);
  Future<void> removeFavourite(String imdbID);
  Future<bool> isFavourite(String imdbID);
}
