import '../entities/movie.dart';
import '../entities/movie_detail.dart';

abstract class MovieRepository {
  Future<List<Movie>> searchMovies(String query);

  Future<MovieDetail> getMovieById(String imdbID);

  Future<List<String>> getFavouriteIds();

  Future<List<Movie>> getFavourites();

  Future<void> addFavourite(Movie movie);

  Future<void> removeFavourite(String imdbID);

  Future<bool> isFavourite(String imdbID);
}
