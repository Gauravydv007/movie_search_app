import 'package:movie_search_app_001/domain/repositories/movie_repository.dart';

class IsFavourite {
  IsFavourite(this._repository);

  final MovieRepository _repository;

  Future<bool> call(String imdbID) => _repository.isFavourite(imdbID);
}
