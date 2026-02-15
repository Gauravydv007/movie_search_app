import 'package:equatable/equatable.dart';

class MovieDetail extends Equatable {
  const MovieDetail({
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
  final List<Rating> ratings;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String type;
  final String boxOffice;

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

class Rating extends Equatable {
  const Rating({required this.source, required this.value});

  final String source;
  final String value;

  @override
  List<Object?> get props => [source, value];
}
