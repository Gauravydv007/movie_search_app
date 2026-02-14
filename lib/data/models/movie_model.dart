import 'package:equatable/equatable.dart';
import 'package:movie_search_app_001/domain/entities/movie.dart';

class MovieModel extends Equatable {
  const MovieModel({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.type,
    required this.poster,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      imdbID: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? '',
      year: json['Year'] as String? ?? '',
      type: json['Type'] as String? ?? 'movie',
      poster: json['Poster'] as String? ?? '',
    );
  }

  final String imdbID;
  final String title;
  final String year;
  final String type;
  final String poster;

  Map<String, dynamic> toJson() => {
        'imdbID': imdbID,
        'Title': title,
        'Year': year,
        'Type': type,
        'Poster': poster,
      };

  Movie toEntity() => Movie(
        imdbID: imdbID,
        title: title,
        year: year,
        type: type,
        poster: poster,
      );

  @override
  List<Object?> get props => [imdbID, title, year, type, poster];
}
