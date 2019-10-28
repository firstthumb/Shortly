import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';

@immutable
abstract class ShortenState extends Equatable {
  ShortenState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends ShortenState {}

class Loading extends ShortenState {}

class Loaded extends ShortenState {
  final List<Shorten> shortens;

  Loaded({
    @required this.shortens,
  }) : super([shortens]);
}

class Error extends ShortenState {
  final String message;

  Error({@required this.message}) : super([message]);
}
