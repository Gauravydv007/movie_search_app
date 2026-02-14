import '../entities/movie.dart';
import '../entities/movie_detail.dart';

/// Abstract contract for movie data (remote + local favourites).
abstract class MovieRepository {
  /// Search movies by title. Requires network.
  Future<List<Movie>> searchMovies(String query);

  /// Get full movie details by imdbID. Requires network.
  Future<MovieDetail> getMovieById(String imdbID);

  /// Get all favourite movie ids (persisted locally).
  Future<List<String>> getFavouriteIds();

  /// Get all favourite movies (ids then fetch details or stored data).
  Future<List<Movie>> getFavourites();

  /// Add a movie to favourites by imdbID.
  Future<void> addFavourite(Movie movie);

  /// Remove a movie from favourites by imdbID.
  Future<void> removeFavourite(String imdbID);

  /// Check if a movie is favourited.
  Future<bool> isFavourite(String imdbID);
}
