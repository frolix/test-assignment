import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/api_repository.dart';
import '../services/shortest_path_calculator.dart';

// --- States ---
abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressRunning extends ProgressState {
  final int progress;

  const ProgressRunning(this.progress);

  @override
  List<Object?> get props => [progress];
}

class ProgressCompleted extends ProgressState {
  final String resultsJson;

  const ProgressCompleted(this.resultsJson);

  @override
  List<Object?> get props => [resultsJson];
}

class ProgressSending extends ProgressState {}

class ProgressSentSuccessfully extends ProgressState {
  final List<Map<String, dynamic>> results;

  const ProgressSentSuccessfully(this.results);

  @override
  List<Object?> get props => [results];
}

class ProgressError extends ProgressState {
  final String error;

  const ProgressError(this.error);

  @override
  List<Object?> get props => [error];
}

// --- Events ---
abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class StartProgress extends ProgressEvent {}

class SendResults extends ProgressEvent {
  final String resultsJson;

  const SendResults(this.resultsJson);

  @override
  List<Object?> get props => [resultsJson];
}

// --- BLoC ---
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final ApiRepository apiRepository;
  final ShortestPathCalculator calculator;

  ProgressBloc(this.apiRepository, this.calculator) : super(ProgressInitial()) {
    on<StartProgress>((event, emit) async {
      try {
        // Завантаження завдань
        final tasks = await apiRepository.fetchTasks();
        final total = tasks.length;

        // Список для збереження результатів
        List<Map<String, dynamic>> results = [];

        // Прорахунок із прогресом
        for (int i = 0; i < total; i++) {
          final task = tasks[i];
          final path = calculator.findShortestPath(
              task['field'], task['start'], task['end']);

          if (path.isNotEmpty) {
            final pathString =
                path.map((step) => "(${step['x']},${step['y']})").join("->");

            // Додати `field` у результат
            results.add({
              "id": task['id'],
              "field": task['field'], // Додаємо поле
              "result": {
                "steps": path,
                "path": pathString,
              },
            });
          }
          // Оновлення прогресу
          emit(ProgressRunning(((i + 1) / total * 100).toInt()));
          await Future.delayed(const Duration(
              milliseconds: 500)); // Симуляція затримки щоб краще виглядало)
        }

        // Конвертація результатів у JSON
        final resultsJson = jsonEncode(results);

        // Завершення обчислень із результатами
        emit(ProgressCompleted(resultsJson));
      } catch (e) {
        emit(ProgressError(e.toString()));
      }
    });

    on<SendResults>((event, emit) async {
      emit(ProgressSending());
      try {
        final results = (jsonDecode(event.resultsJson) as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        // Відправка результатів через репозиторій
        final response = await apiRepository.sendResults(results);

        if (!response['error']) {
          // Передаємо результати в стан
          emit(ProgressSentSuccessfully(results));
        } else {
          emit(ProgressError(response['message']));
        }
      } catch (e) {
        emit(ProgressError(e.toString()));
      }
    });
  }
}
