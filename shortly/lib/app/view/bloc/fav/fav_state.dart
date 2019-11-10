import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';

@immutable
abstract class FavState extends Equatable {
  FavState([List props = const <dynamic>[]]) : super(props);
}

class FavEmpty extends FavState {}

class FavLoading extends FavState {}

class FavLoaded extends FavState {
  final List<Shorten> shortens;

  FavLoaded({
    @required this.shortens,
  }) : super([shortens]);
}

class FavError extends FavState {
  final String message;

  FavError({@required this.message}) : super([message]);
}
