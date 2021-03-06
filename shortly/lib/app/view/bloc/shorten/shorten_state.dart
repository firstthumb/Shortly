import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';

@immutable
abstract class ShortenState extends Equatable {
  ShortenState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends ShortenState {}

class Loading extends ShortenState {}

class Created extends ShortenState {
  final Shorten shorten;
  final bool sharedIntent;

  Created({
    @required this.sharedIntent,
    @required this.shorten,
  }) : super([shorten, sharedIntent]);
}

class Loaded extends ShortenState {
  final List<Shorten> shortens;

  Loaded({
    @required this.shortens,
  }) : super([shortens]);
}

class Toggled extends ShortenState {}

class Error extends ShortenState {
  final String message;

  Error({@required this.message}) : super([message]);
}

class Syncing extends ShortenState {}

class Synced extends ShortenState {
  final List<Shorten> shortens;

  Synced({
    @required this.shortens,
  }) : super([shortens]);
}
