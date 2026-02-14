import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_app_001/core/error/exceptions.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/domain/usecases/search_movies.dart';

part 'search_movies_event.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  SearchMoviesBloc(this._searchMovies) : super(SearchMoviesInitial()) {
    on<SearchMoviesQueryChanged>(_onQueryChanged);
    on<SearchMoviesClear>(_onClear);
  }

  final SearchMovies _searchMovies;

  Future<void> _onQueryChanged(
    SearchMoviesQueryChanged event,
    Emitter<SearchMoviesState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchMoviesInitial());
      return;
    }

    emit(SearchMoviesLoading());
    try {
      final list = await _searchMovies(query);
      emit(SearchMoviesLoaded(list));
    } on NetworkException catch (e) {
      emit(SearchMoviesError(e.message ?? 'No internet connection'));
    } on ServerException catch (e) {
      emit(SearchMoviesError(e.message ?? 'Search failed'));
    } catch (e) {
      emit(SearchMoviesError(e.toString()));
    }
  }

  void _onClear(SearchMoviesClear event, Emitter<SearchMoviesState> emit) {
    emit(SearchMoviesInitial());
  }
}
