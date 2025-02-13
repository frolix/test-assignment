import 'package:equatable/equatable.dart';

class UrlState extends Equatable {
  final String? url;
  final String? error;

  const UrlState({this.url, this.error});

  UrlState copyWith({String? url, String? error}) {
    return UrlState(
      url: url ?? this.url,
      error: error,
    );
  }

  @override
  List<Object?> get props => [url, error];
}
