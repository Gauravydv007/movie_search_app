import 'package:flutter/material.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({
    super.key,
    required this.movie,
    required this.onTap,
    this.compact = false,
  });

  final Movie movie;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactTile(movie: movie, onTap: onTap);
    }
    return _ListTile(movie: movie, onTap: onTap);
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _Poster(url: movie.poster, size: 56),
      title: Text(
        movie.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('${movie.year} · ${movie.type}'),
      onTap: onTap,
    );
  }
}

class _CompactTile extends StatelessWidget {
  const _CompactTile({required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _Poster(url: movie.poster, size: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
  const _Poster({required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || url == 'N/A') {
      return SizedBox(
        width: size,
        height: size,
        child: const Icon(Icons.movie, size: 48),
      );
    }
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => SizedBox(
        width: size,
        height: size,
        child: const Icon(Icons.broken_image),
      ),
    );
  }
}
