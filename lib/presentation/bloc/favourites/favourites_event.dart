part of 'favourites_bloc.dart';

abstract class FavouritesEvent extends Equatable {
  const FavouritesEvent();

  @override
  List<Object?> get props => [];
}

class FavouritesLoadRequested extends FavouritesEvent {
  const FavouritesLoadRequested();
}

class FavouritesAddRequested extends FavouritesEvent {
  const FavouritesAddRequested(this.movie);
  final Movie movie;
  @override
  List<Object?> get props => [movie];
}

class FavouritesRemoveRequested extends FavouritesEvent {
  const FavouritesRemoveRequested(this.imdbID);
  final String imdbID;
  @override
  List<Object?> get props => [imdbID];
}
