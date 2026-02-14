import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/domain/repositories/movie_repository.dart';

class GetFavourites {
  GetFavourites(this._repository);

  final MovieRepository _repository;

  Future<List<Movie>> call() => _repository.getFavourites();
}
