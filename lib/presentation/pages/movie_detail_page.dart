import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/domain/entities/movie_detail.dart';
import 'package:movie_search_app_001/injection/injection.dart';
import 'package:movie_search_app_001/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:movie_search_app_001/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie_search_app_001/presentation/widgets/loading_indicator.dart';
import 'package:movie_search_app_001/presentation/widgets/error_message.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.imdbID});

  final String imdbID;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<MovieDetailBloc>()..add(MovieDetailLoadRequested(imdbID)),
        ),
      ],
      child: _MovieDetailView(imdbID: imdbID),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  const _MovieDetailView({required this.imdbID});

  final String imdbID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const LoadingIndicator();
          }
          if (state is MovieDetailError) {
            return ErrorMessage(message: state.message);
          }
          if (state is MovieDetailLoaded) {
            return _DetailContent(
              movie: state.movie,
              isFavourite: state.isFavourite,
              onBack: () => Navigator.of(context).pop(),
              onFavouriteTap: () => _toggleFavourite(context, state),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _toggleFavourite(BuildContext context, MovieDetailLoaded state) {
    final isFav = !state.isFavourite;
    context.read<MovieDetailBloc>().add(MovieDetailFavouriteToggled(isFav));
    final movie = Movie(
      imdbID: state.movie.imdbID,
      title: state.movie.title,
      year: state.movie.year,
      type: state.movie.type,
      poster: state.movie.poster,
    );
    if (isFav) {
      context.read<FavouritesBloc>().add(FavouritesAddRequested(movie));
    } else {
      context.read<FavouritesBloc>().add(
        FavouritesRemoveRequested(state.movie.imdbID),
      );
    }
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.movie,
    required this.isFavourite,
    required this.onBack,
    required this.onFavouriteTap,
  });

  final MovieDetail movie;
  final bool isFavourite;
  final VoidCallback onBack;
  final VoidCallback onFavouriteTap;

  static const _cardRadius = 24.0;
  static const _navButtonSize = 44.0;
  static const _infoBlue = Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // Full background image
        _BackgroundPoster(poster: movie.poster),

        // Navigation buttons
        Positioned(
          top: topPadding + 8,
          left: 16,
          child: _CircleButton(icon: Icons.arrow_back, onPressed: onBack),
        ),
        Positioned(
          top: topPadding + 8,
          right: 16,
          child: _CircleButton(
            icon: isFavourite ? Icons.favorite : Icons.favorite_border,
            onPressed: onFavouriteTap,
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: screenHeight * 0.65,
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(_cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _subtitle(movie),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _infoBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _GenrePills(genre: movie.genre),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey.shade300, thickness: 1),
                      const SizedBox(height: 6),
                      _ScoresRow(movie: movie),
                      const SizedBox(height: 6),
                      Divider(color: Colors.grey.shade300, thickness: 1),
                      const SizedBox(height: 18),
                      _SectionLabel('PLOT'),
                      const SizedBox(height: 6),
                      Text(
                        movie.plot != 'N/A'
                            ? movie.plot
                            : 'No plot is available.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SectionLabel('CAST & CREW'),
                      const SizedBox(height: 12),
                      _CastCrewList(movie: movie),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _subtitle(MovieDetail m) {
    final parts = <String>[];
    if (m.year != 'N/A') parts.add(m.year);
    if (m.rated != 'N/A') parts.add(m.rated);
    if (m.runtime != 'N/A') parts.add(m.runtime);
    return parts.isEmpty ? '—' : parts.join(' • ');
  }
}

class _BackgroundPoster extends StatelessWidget {
  const _BackgroundPoster({required this.poster});

  final String poster;

  @override
  Widget build(BuildContext context) {
    final hasImage = poster.isNotEmpty && poster != 'N/A';

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            Image.network(
              poster,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _Placeholder(),
            )
          else
            _Placeholder(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.8),
                  Colors.white,
                  Colors.white,
                ],
                stops: const [0.0, 0.3, 0.4, 0.7, 0.9, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade400,
      child: Icon(Icons.movie_outlined, size: 80, color: Colors.grey.shade600),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.3),
      shape: CircleBorder(side: BorderSide(color: Colors.white54, width: 1)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class _GenrePills extends StatelessWidget {
  const _GenrePills({required this.genre});

  final String genre;

  static const _pillBlue = Color(0xFFE3F2FD);
  static const _pillTextBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    if (genre == 'N/A' || genre.isEmpty) return const SizedBox.shrink();
    final list = genre
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    if (list.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: list
          .map(
            (g) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _pillBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                g.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _pillTextBlue,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ScoresRow extends StatelessWidget {
  const _ScoresRow({required this.movie});

  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    final imdb = _parseImdb(movie);
    final rt = _parseRottenTomatoes(movie);
    final meta = _parseMetacritic(movie);

    final scores = [
      if (imdb != null)
        _ScoreData(
          icon: Icons.star,
          iconColor: const Color(0xFFFFC107),
          score: imdb.score,
          suffix: imdb.suffix,
          label: 'IMDB',
        ),
      if (rt != null)
        _ScoreData(
          icon: Icons.local_movies,
          iconColor: const Color(0xFFE53935),
          score: rt.score,
          suffix: rt.suffix,
          label: 'ROTTEN TOMATOES',
        ),
      if (meta != null)
        _ScoreData(
          icon: Icons.trending_up,
          iconColor: const Color(0xFF43A047),
          score: meta.score,
          suffix: meta.suffix,
          label: 'METACRITIC',
        ),
    ];

    if (scores.isEmpty) return const SizedBox.shrink();

    return Row(
      children: List.generate(scores.length * 2 - 1, (index) {
        if (index.isOdd) {
          return Container(
            width: 1,
            height: 50,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          );
        } else {
          final scoreIndex = index ~/ 2;
          final data = scores[scoreIndex];
          return Expanded(
            child: _ScoreItem(
              icon: data.icon,
              iconColor: data.iconColor,
              score: data.score,
              suffix: data.suffix,
              label: data.label,
            ),
          );
        }
      }),
    );
  }

  ({String score, String suffix})? _parseImdb(MovieDetail m) {
    if (m.imdbRating != 'N/A' && m.imdbRating.isNotEmpty) {
      return (score: m.imdbRating, suffix: '/10');
    }
    for (final r in m.ratings) {
      if (r.source.toLowerCase().contains('internet') ||
          r.source == 'Internet Movie Database') {
        final v = r.value.replaceFirst('/10', '').trim();
        return (score: v, suffix: '/10');
      }
    }
    return null;
  }

  ({String score, String suffix})? _parseRottenTomatoes(MovieDetail m) {
    for (final r in m.ratings) {
      if (r.source.toLowerCase().contains('rotten')) {
        return (score: r.value, suffix: '');
      }
    }
    return null;
  }

  ({String score, String suffix})? _parseMetacritic(MovieDetail m) {
    if (m.metascore != 'N/A' && m.metascore.isNotEmpty) {
      return (score: m.metascore, suffix: '/100');
    }
    for (final r in m.ratings) {
      if (r.source.toLowerCase().contains('metacritic')) {
        final v = r.value.replaceFirst('/100', '').trim();
        return (score: v, suffix: '/100');
      }
    }
    return null;
  }
}

class _ScoreData {
  const _ScoreData({
    required this.icon,
    required this.iconColor,
    required this.score,
    required this.suffix,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String score;
  final String suffix;
  final String label;
}

class _ScoreItem extends StatelessWidget {
  const _ScoreItem({
    required this.icon,
    required this.iconColor,
    required this.score,
    required this.suffix,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String score;
  final String suffix;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 4),
            Text(
              score,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            if (suffix.isNotEmpty)
              Text(
                suffix,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
          ],
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade500,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _CastCrewList extends StatelessWidget {
  const _CastCrewList({required this.movie});

  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    final items = <_CastCrewItem>[];

    if (movie.director != 'N/A' && movie.director.isNotEmpty) {
      for (final name in movie.director.split(',').map((e) => e.trim())) {
        if (name.isNotEmpty) {
          items.add(
            _CastCrewItem(name: name, role: 'Director', isDirector: true),
          );
        }
      }
    }

    if (movie.actors != 'N/A' && movie.actors.isNotEmpty) {
      final actors = movie.actors.split(',').map((e) => e.trim()).toList();
      for (int i = 0; i < actors.length && i < 4; i++) {
        final name = actors[i];
        if (name.isNotEmpty) {
          items.add(
            _CastCrewItem(
              name: name,
              role: _getActorRole(i, movie),
              isDirector: false,
            ),
          );
        }
      }
    }

    if (items.isEmpty) {
      return Text(
        'No cast or crew information available.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
      );
    }

    return Column(
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  _AvatarCircle(isDirector: e.isDirector),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          e.role,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  String _getActorRole(int index, MovieDetail movie) {

    return 'Actor';
  }
}

class _CastCrewItem {
  _CastCrewItem({
    required this.name,
    required this.role,
    required this.isDirector,
  });
  final String name;
  final String role;
  final bool isDirector;
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.isDirector});

  final bool isDirector;

  static const _directorBlue = Color(0xFFE3F2FD);
  static const _directorIconBlue = Color(0xFF1565C0);
  static const _actorBg = Color(0xFFFFE0B2);
  static const _actorIcon = Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDirector ? _directorBlue : _actorBg,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isDirector ? Icons.videocam : Icons.person,
        size: 24,
        color: isDirector ? _directorIconBlue : _actorIcon,
      ),
    );
  }
}
