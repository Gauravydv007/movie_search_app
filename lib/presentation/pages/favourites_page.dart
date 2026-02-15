import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:movie_search_app_001/presentation/pages/movie_detail_page.dart';
import 'package:movie_search_app_001/presentation/widgets/loading_indicator.dart';
import 'package:movie_search_app_001/presentation/widgets/error_message.dart';
import 'package:movie_search_app_001/presentation/widgets/movie_list_item.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FavouritesView();
  }
}


class _FavouritesView extends StatelessWidget {
  const _FavouritesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: BlocBuilder<FavouritesBloc, FavouritesState>(
        builder: (context, state) {
          if (state is FavouritesLoading) {
            return const LoadingIndicator();
          }
          if (state is FavouritesError) {
            return ErrorMessage(message: state.message);
          }
          if (state is FavouritesLoaded) {
            if (state.movies.isEmpty) {
              return const Center(
                child: Text('No favourites yet. Add some from search!!'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FavouritesBloc>().add(const FavouritesLoadRequested());
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieListItem(
                    movie: movie,
                    onTap: () => _openDetail(context, movie),
                    compact: true,
                  );
                },
              ),
            );
          }
          return Center(child: Text('Pull to load favourites'));
        },
      ),
    );
  }

  void _openDetail(BuildContext context, Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MovieDetailPage(imdbID: movie.imdbID),
      ),
    ).then((_) {
      context.read<FavouritesBloc>().add(const FavouritesLoadRequested());
    });
  }
}
