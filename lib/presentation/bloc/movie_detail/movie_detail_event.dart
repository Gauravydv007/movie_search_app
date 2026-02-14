part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object?> get props => [];
}

class MovieDetailLoadRequested extends MovieDetailEvent {
  const MovieDetailLoadRequested(this.imdbID);
  final String imdbID;
  @override
  List<Object?> get props => [imdbID];
}

class MovieDetailFavouriteToggled extends MovieDetailEvent {
  const MovieDetailFavouriteToggled(this.isFavourite);
  final bool isFavourite;
  @override
  List<Object?> get props => [isFavourite];
}
