import 'package:equatable/equatable.dart';
import 'package:movie_search_app_001/domain/entities/movie_detail.dart';

class MovieDetailModel extends Equatable {
  const MovieDetailModel({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.ratings,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.type,
    required this.boxOffice,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    final ratingsList = json['Ratings'] as List<dynamic>?;
    final ratings = ratingsList
            ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <RatingModel>[];

    return MovieDetailModel(
      imdbID: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? '',
      year: json['Year'] as String? ?? '',
      rated: json['Rated'] as String? ?? 'N/A',
      released: json['Released'] as String? ?? 'N/A',
      runtime: json['Runtime'] as String? ?? 'N/A',
      genre: json['Genre'] as String? ?? 'N/A',
      director: json['Director'] as String? ?? 'N/A',
      writer: json['Writer'] as String? ?? 'N/A',
      actors: json['Actors'] as String? ?? 'N/A',
      plot: json['Plot'] as String? ?? 'N/A',
      language: json['Language'] as String? ?? 'N/A',
      country: json['Country'] as String? ?? 'N/A',
      awards: json['Awards'] as String? ?? 'N/A',
      poster: json['Poster'] as String? ?? '',
      ratings: ratings,
      metascore: json['Metascore'] as String? ?? 'N/A',
      imdbRating: json['imdbRating'] as String? ?? 'N/A',
      imdbVotes: json['imdbVotes'] as String? ?? 'N/A',
      type: json['Type'] as String? ?? 'movie',
      boxOffice: json['BoxOffice'] as String? ?? 'N/A',
    );
  }

  final String imdbID;
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final List<RatingModel> ratings;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String type;
  final String boxOffice;

  MovieDetail toEntity() => MovieDetail(
        imdbID: imdbID,
        title: title,
        year: year,
        rated: rated,
        released: released,
        runtime: runtime,
        genre: genre,
        director: director,
        writer: writer,
        actors: actors,
        plot: plot,
        language: language,
        country: country,
        awards: awards,
        poster: poster,
        ratings: ratings.map((e) => Rating(source: e.source, value: e.value)).toList(),
        metascore: metascore,
        imdbRating: imdbRating,
        imdbVotes: imdbVotes,
        type: type,
        boxOffice: boxOffice,
      );

  @override
  List<Object?> get props => [
        imdbID,
        title,
        year,
        rated,
        released,
        runtime,
        genre,
        director,
        writer,
        actors,
        plot,
        language,
        country,
        awards,
        poster,
        ratings,
        metascore,
        imdbRating,
        imdbVotes,
        type,
        boxOffice,
      ];
}

class RatingModel extends Equatable {
  const RatingModel({required this.source, required this.value});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      source: json['Source'] as String? ?? '',
      value: json['Value'] as String? ?? '',
    );
  }

  final String source;
  final String value;

  @override
  List<Object?> get props => [source, value];
}
