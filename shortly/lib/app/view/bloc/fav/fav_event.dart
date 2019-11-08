import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';

@immutable
abstract class FavEvent extends Equatable {
  FavEvent([List props = const <dynamic>[]]) : super(props);
}

class FavListEvent extends FavEvent {
  final List<Shorten> shortens;

  FavListEvent({this.shortens}) : super([shortens]);

  @override
  String toString() => "GetShortenListEvent{ }";
}
