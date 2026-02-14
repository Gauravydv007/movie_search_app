part of 'search_movies_bloc.dart';

abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();

  @override
  List<Object?> get props => [];
}

class SearchMoviesInitial extends SearchMoviesState {}

class SearchMoviesLoading extends SearchMoviesState {}

class SearchMoviesLoaded extends SearchMoviesState {
  const SearchMoviesLoaded(this.movies);
  final List<Movie> movies;
  @override
  List<Object?> get props => [movies];
}

class SearchMoviesError extends SearchMoviesState {
  const SearchMoviesError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
