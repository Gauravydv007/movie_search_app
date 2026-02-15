import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movie_search_app_001/core/network/network_info.dart';
import 'package:movie_search_app_001/core/network/network_info_impl.dart';
import 'package:movie_search_app_001/data/datasources/movie_local_datasource.dart';
import 'package:movie_search_app_001/data/datasources/movie_local_datasource_impl.dart';
import 'package:movie_search_app_001/data/datasources/movie_remote_datasource.dart';
import 'package:movie_search_app_001/data/datasources/movie_remote_datasource_impl.dart';
import 'package:movie_search_app_001/data/repositories/movie_repository_impl.dart';
import 'package:movie_search_app_001/domain/repositories/movie_repository.dart';
import 'package:movie_search_app_001/domain/usecases/add_favourite.dart';
import 'package:movie_search_app_001/domain/usecases/get_favourites.dart';
import 'package:movie_search_app_001/domain/usecases/get_movie_by_id.dart';
import 'package:movie_search_app_001/domain/usecases/is_favourite.dart';
import 'package:movie_search_app_001/domain/usecases/remove_favourite.dart';
import 'package:movie_search_app_001/domain/usecases/search_movies.dart';
import 'package:movie_search_app_001/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:movie_search_app_001/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:movie_search_app_001/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie_search_app_001/presentation/bloc/search/search_movies_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => SearchMoviesBloc(sl()));
  sl.registerFactory(() => MovieDetailBloc(sl(), sl()));
  sl.registerFactory(() => FavouritesBloc(sl(), sl(), sl()));
  sl.registerFactory(() => ConnectivityBloc(sl()));

  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieById(sl()));
  sl.registerLazySingleton(() => GetFavourites(sl()));
  sl.registerLazySingleton(() => AddFavourite(sl()));
  sl.registerLazySingleton(() => RemoveFavourite(sl()));
  sl.registerLazySingleton(() => IsFavourite(sl()));


  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remote: sl(),
      local: sl(),
      networkInfo: sl(),
    ),
  );


  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(sl()),
  );


  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
}
