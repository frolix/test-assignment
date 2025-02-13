import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/blocs/url_bloc.dart';
import 'package:test/ui/screens/url_input_screen.dart';
import 'ui/screens/progress_screen.dart';
import 'ui/screens/results_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UrlBloc(),
      child: MaterialApp(
        title: 'FlutterTest',
        initialRoute: '/',
        routes: {
          '/': (context) => UrlInputScreen(),
          '/progress': (context) => const ProgressScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/results') {
            final results = settings.arguments as List<Map<String, dynamic>>;
            return MaterialPageRoute(
              builder: (context) => ResultsScreen(results: results),
            );
          }
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Page not found')),
            ),
          );
        },
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
