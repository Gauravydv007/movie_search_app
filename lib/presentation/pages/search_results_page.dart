import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:movie_search_app_001/presentation/bloc/search/search_movies_bloc.dart';
import 'package:movie_search_app_001/presentation/widgets/error_message.dart';
import 'package:movie_search_app_001/presentation/widgets/loading_indicator.dart';
import 'package:movie_search_app_001/presentation/widgets/movie_grid_card.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({
    super.key,
    required this.initialQuery,
  });

  final String initialQuery;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    context.read<SearchMoviesBloc>().add(const SearchMoviesClear());
    if (mounted) Navigator.of(context).pop();
  }

  void _onSubmit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    context.read<SearchMoviesBloc>().add(SearchMoviesQueryChanged(query));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Search Results',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              
              controller: _controller,
              onSubmitted: _onSubmit,
              decoration: InputDecoration(
                hintText: 'Search for your favorite movies',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: _onClear,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
              builder: (context, state) {
                if (state is SearchMoviesInitial) {
                  return const SizedBox.shrink();
                }
                if (state is SearchMoviesLoading) {
                  return const LoadingIndicator();
                }
                if (state is SearchMoviesError) {
                  return ErrorMessage(message: state.message);
                }
                if (state is SearchMoviesLoaded) {
                  final movies = state.movies;
                  final count = movies.length;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Text(
                          '$count ${count == 1 ? 'movie' : 'movies'} found',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return BlocBuilder<FavouritesBloc, FavouritesState>(
                              builder: (context, favState) {
                                final isFav = favState is FavouritesLoaded &&
                                    favState.movies
                                        .any((m) => m.imdbID == movie.imdbID);
                                return MovieGridCard(
                                  movie: movie,
                                  isFavourite: isFav,
                                  onFavouriteTap: () =>
                                      _toggleFavourite(context, movie, isFav),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavourite(BuildContext context, Movie movie, bool isFavourite) {
    if (isFavourite) {
      context
          .read<FavouritesBloc>()
          .add(FavouritesRemoveRequested(movie.imdbID));
    } else {
      context.read<FavouritesBloc>().add(FavouritesAddRequested(movie));
    }
  }
}
