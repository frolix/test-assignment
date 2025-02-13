import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/progress_bloc.dart';
import 'results_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  ProgressScreenState createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProgressBloc>().add(StartProgress());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Process screen')),
      body: BlocConsumer<ProgressBloc, ProgressState>(
        listener: (context, state) {
          if (state is ProgressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is ProgressSentSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Results successfully sent to the server!')),
            );
            // Переходимо до ResultsScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsScreen(results: state.results),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProgressRunning) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Calculating: ${state.progress}%',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          } else if (state is ProgressCompleted) {
            return Stack(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "All calculations have finished, you can send your results to the server.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: TextButton(
                      onPressed: () => context
                          .read<ProgressBloc>()
                          .add(SendResults(state.resultsJson)),
                      child: const Text(
                        "Send results to server",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ProgressSending) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Sending results to the server...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (state is ProgressError) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
