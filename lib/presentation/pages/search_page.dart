import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/injection/injection.dart';
import 'package:movie_search_app_001/presentation/bloc/search/search_movies_bloc.dart';
import 'package:movie_search_app_001/presentation/pages/movie_detail_page.dart';
import 'package:movie_search_app_001/presentation/widgets/movie_list_item.dart';
import 'package:movie_search_app_001/presentation/widgets/loading_indicator.dart';
import 'package:movie_search_app_001/presentation/widgets/error_message.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchMoviesBloc>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  bool _isGrid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search by title...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchMoviesBloc>().add(const SearchMoviesClear());
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<SearchMoviesBloc>().add(SearchMoviesQueryChanged(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
              builder: (context, state) {
                if (state is SearchMoviesInitial) {
                  return const Center(
                    child: Text('Type to search movies'),
                  );
                }
                if (state is SearchMoviesLoading) {
                  return const LoadingIndicator();
                }
                if (state is SearchMoviesError) {
                  return ErrorMessage(message: state.message);
                }
                if (state is SearchMoviesLoaded) {
                  if (state.movies.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }
                  return _isGrid
                      ? _buildGrid(state.movies)
                      : _buildList(state.movies);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Movie> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieListItem(
          movie: movie,
          onTap: () => _openDetail(context, movie),
        );
      },
    );
  }

  Widget _buildGrid(List<Movie> movies) {
    return GridView.builder(
      padding: EdgeInsets.all(12),
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieListItem(
          movie: movie,
          onTap: () => _openDetail(context, movie),
          compact: true,
        );
      },
    );
  }

  void _openDetail(BuildContext context, Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MovieDetailPage(imdbID: movie.imdbID),
      ),
    );
  }
}
