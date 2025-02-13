import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/url_bloc.dart';
import '../../blocs/progress_bloc.dart';
import '../../data/models/url_state.dart';
import '../../data/repositories/api_repository.dart';
import '../../services/shortest_path_calculator.dart';
import 'progress_screen.dart';

class UrlInputScreen extends StatelessWidget {
  final TextEditingController _urlController = TextEditingController(
    text:
        'https://flutter.webspark.dev/flutter/api', // Значення за замовчуванням
  );

  UrlInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: BlocConsumer<UrlBloc, UrlState>(
        listener: (context, state) {
          if (state.url != null) {
            // Переходимо на екран прогресу передаючи URL у ProgressBloc
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => ProgressBloc(
                    ApiRepository(state.url!),
                    ShortestPathCalculator(),
                  ),
                  child: const ProgressScreen(),
                ),
              ),
            ).then((_) {
              // Скидаємо стан UrlBloc після повернення щоб відправити запит заново
              context.read<UrlBloc>().add(ResetUrlState());
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Set valid API base URL in order to continue',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'API URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final url = _urlController.text;
                    context.read<UrlBloc>().add(ValidateUrl(url));
                  },
                  child: const Text('Start counting process'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
