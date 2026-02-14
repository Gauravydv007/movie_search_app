import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/domain/repositories/movie_repository.dart';

class SearchMovies {
  SearchMovies(this._repository);

  final MovieRepository _repository;

  Future<List<Movie>> call(String query) => _repository.searchMovies(query);
}
