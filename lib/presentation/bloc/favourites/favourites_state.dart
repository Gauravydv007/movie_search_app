part of 'favourites_bloc.dart';

abstract class FavouritesState extends Equatable {
  const FavouritesState();

  @override
  List<Object?> get props => [];
}

class FavouritesInitial extends FavouritesState {}

class FavouritesLoading extends FavouritesState {}

class FavouritesLoaded extends FavouritesState {
  const FavouritesLoaded(this.movies);
  final List<Movie> movies;
  @override
  List<Object?> get props => [movies];
}

class FavouritesError extends FavouritesState {
  const FavouritesError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
