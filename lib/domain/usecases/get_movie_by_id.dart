import 'package:movie_search_app_001/domain/entities/movie_detail.dart';
import 'package:movie_search_app_001/domain/repositories/movie_repository.dart';

class GetMovieById {
  GetMovieById(this._repository);

  final MovieRepository _repository;

  Future<MovieDetail> call(String imdbID) => _repository.getMovieById(imdbID);
}
