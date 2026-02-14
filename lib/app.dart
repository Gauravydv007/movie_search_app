import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app_001/injection/injection.dart';
import 'package:movie_search_app_001/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:movie_search_app_001/presentation/pages/home_shell.dart';

class MovieSearchApp extends StatelessWidget {
  const MovieSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<FavouritesBloc>();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          bloc.add(const FavouritesLoadRequested());
        });
        return bloc;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Search',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeShell(),
      ),
    );
  }
}
