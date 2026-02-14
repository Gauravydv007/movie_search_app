part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  const MovieDetailLoaded(this.movie, this.isFavourite);
  final MovieDetail movie;
  final bool isFavourite;
  @override
  List<Object?> get props => [movie, isFavourite];
}

class MovieDetailError extends MovieDetailState {
  const MovieDetailError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
