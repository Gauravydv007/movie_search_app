part of 'search_movies_bloc.dart';

abstract class SearchMoviesEvent extends Equatable {
  const SearchMoviesEvent();

  @override
  List<Object?> get props => [];
}

class SearchMoviesQueryChanged extends SearchMoviesEvent {
  const SearchMoviesQueryChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class SearchMoviesClear extends SearchMoviesEvent {
  const SearchMoviesClear();
}
