import 'package:flutter/material.dart';

import 'package:movie_search_app_001/app.dart';
import 'package:movie_search_app_001/injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MovieSearchApp());
}
