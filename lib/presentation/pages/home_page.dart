import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app_001/injection/injection.dart';
import 'package:movie_search_app_001/presentation/bloc/search/search_movies_bloc.dart';
import 'package:movie_search_app_001/presentation/pages/search_results_page.dart';

/// Screen 1: Initial search screen with title, search bar, and placeholder.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) =>
              sl<SearchMoviesBloc>()..add(SearchMoviesQueryChanged(query)),
          child: SearchResultsPage(initialQuery: query),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Search',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSubmitted: (_) => _submitSearch(),
                  decoration: InputDecoration(
                    hintText: 'Search for your favorite movies',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
