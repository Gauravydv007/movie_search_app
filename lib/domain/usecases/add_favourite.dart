import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/domain/repositories/movie_repository.dart';

class AddFavourite {
  AddFavourite(this._repository);

  final MovieRepository _repository;

  Future<void> call(Movie movie) => _repository.addFavourite(movie);
}
