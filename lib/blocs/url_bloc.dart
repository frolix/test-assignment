import 'package:bloc/bloc.dart';
import '../data/models/url_state.dart';

// --- Events ---
abstract class UrlEvent {
  const UrlEvent();
}

class ResetUrlState extends UrlEvent {}

class ValidateUrl extends UrlEvent {
  final String url;

  const ValidateUrl(this.url);
}

// --- BLoC ---
class UrlBloc extends Bloc<UrlEvent, UrlState> {
  UrlBloc() : super(const UrlState()) {
    on<ValidateUrl>((event, emit) {
      final isValid = Uri.tryParse(event.url)?.isAbsolute ?? false;
      if (isValid) {
        emit(state.copyWith(url: event.url, error: null));
      } else {
        emit(state.copyWith(error: "Invalid URL"));
      }
    });

    on<ResetUrlState>((event, emit) {
      emit(const UrlState()); // Скидаємо стан до початкового
    });
  }
}
