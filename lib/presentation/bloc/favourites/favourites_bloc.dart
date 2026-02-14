import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_app_001/core/error/exceptions.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/domain/usecases/add_favourite.dart';
import 'package:movie_search_app_001/domain/usecases/get_favourites.dart';
import 'package:movie_search_app_001/domain/usecases/remove_favourite.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  FavouritesBloc(this._getFavourites, this._addFavourite, this._removeFavourite)
      : super(FavouritesInitial()) {
    on<FavouritesLoadRequested>(_onLoadRequested);
    on<FavouritesAddRequested>(_onAddRequested);
    on<FavouritesRemoveRequested>(_onRemoveRequested);
  }

  final GetFavourites _getFavourites;
  final AddFavourite _addFavourite;
  final RemoveFavourite _removeFavourite;

  Future<void> _onLoadRequested(
    FavouritesLoadRequested event,
    Emitter<FavouritesState> emit,
  ) async {
    emit(FavouritesLoading());
    try {
      final list = await _getFavourites();
      emit(FavouritesLoaded(list));
    } on CacheException catch (e) {
      emit(FavouritesError(e.message ?? 'Failed to load favourites'));
    } catch (e) {
      emit(FavouritesError(e.toString()));
    }
  }

  Future<void> _onAddRequested(
    FavouritesAddRequested event,
    Emitter<FavouritesState> emit,
  ) async {
    try {
      await _addFavourite(event.movie);
      add(const FavouritesLoadRequested());
    } on CacheException catch (e) {
      emit(FavouritesError(e.message ?? 'Failed to add favourite'));
    }
  }

  Future<void> _onRemoveRequested(
    FavouritesRemoveRequested event,
    Emitter<FavouritesState> emit,
  ) async {
    try {
      await _removeFavourite(event.imdbID);
      add(const FavouritesLoadRequested());
    } on CacheException catch (e) {
      emit(FavouritesError(e.message ?? 'Failed to remove favourite'));
    }
  }
}
