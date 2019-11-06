import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ShortenEvent extends Equatable {
  ShortenEvent([List props = const <dynamic>[]]) : super(props);
}

class GetShortenListEvent extends ShortenEvent {
  GetShortenListEvent() : super([]);

  @override
  String toString() => "GetShortenListEvent{ }";
}

class CreateShortenEvent extends ShortenEvent {
  final String link;

  CreateShortenEvent({this.link}) : super([link]);

  @override
  String toString() => "CreateShortenEvent{ link: $link }";
}

class ToggleFavShortenEvent extends ShortenEvent {
  final String id;

  ToggleFavShortenEvent({this.id}) : super([id]);

  @override
  String toString() => 'ToggleFavShortenEvent{id: $id}';
}
