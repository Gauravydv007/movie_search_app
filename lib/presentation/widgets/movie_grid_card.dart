import 'package:flutter/material.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';
import 'package:movie_search_app_001/presentation/pages/movie_detail_page.dart';

/// Grid card for search results: poster (or placeholder), heart, title, year.
class MovieGridCard extends StatelessWidget {
  const MovieGridCard({
    super.key,
    required this.movie,
    required this.isFavourite,
    required this.onFavouriteTap,
  });

  final Movie movie;
  final bool isFavourite;
  final VoidCallback onFavouriteTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => MovieDetailPage(imdbID: movie.imdbID),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _Poster(url: movie.poster),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        onFavouriteTap();
                      },
                      child: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: isFavourite ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(
                movie.year,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || url == 'N/A') {
      return Container(
        color: Colors.grey.shade300,
        child: Icon(
          Icons.movie_outlined,
          size: 56,
          color: Colors.grey.shade600,
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade300,
        child: Icon(
          Icons.movie_outlined,
          size: 56,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
