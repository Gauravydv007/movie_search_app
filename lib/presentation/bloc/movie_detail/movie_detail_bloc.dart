import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_app_001/core/error/exceptions.dart';
import 'package:movie_search_app_001/domain/entities/movie_detail.dart';
import 'package:movie_search_app_001/domain/usecases/get_movie_by_id.dart';
import 'package:movie_search_app_001/domain/usecases/is_favourite.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc(this._getMovieById, this._isFavourite)
      : super(MovieDetailInitial()) {
    on<MovieDetailLoadRequested>(_onLoadRequested);
    on<MovieDetailFavouriteToggled>(_onFavouriteToggled);
  }

  final GetMovieById _getMovieById;
  final IsFavourite _isFavourite;

  Future<void> _onLoadRequested(
    MovieDetailLoadRequested event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    try {
      final detail = await _getMovieById(event.imdbID);
      final isFav = await _isFavourite(event.imdbID);
      emit(MovieDetailLoaded(detail, isFav));
    } on NetworkException catch (e) {
      emit(MovieDetailError(e.message ?? 'No internet connection'));
    } on ServerException catch (e) {
      emit(MovieDetailError(e.message ?? 'Failed to load movie'));
    } catch (e) {
      emit(MovieDetailError(e.toString()));
    }
  }

  Future<void> _onFavouriteToggled(
    MovieDetailFavouriteToggled event,
    Emitter<MovieDetailState> emit,
  ) async {
    final current = state;
    if (current is MovieDetailLoaded) {
      emit(MovieDetailLoaded(current.movie, event.isFavourite));
    }
  }
}
