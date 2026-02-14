import 'package:movie_search_app_001/domain/repositories/movie_repository.dart';

class RemoveFavourite {
  RemoveFavourite(this._repository);

  final MovieRepository _repository;

  Future<void> call(String imdbID) => _repository.removeFavourite(imdbID);
}
