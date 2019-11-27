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
  final String type;

  CreateShortenEvent({this.link, this.type}) : super([link, type]);

  @override
  String toString() => "CreateShortenEvent{ link: $link, type: $type }";
}

class DeleteShortenEvent extends ShortenEvent {
  final String id;

  DeleteShortenEvent({this.id}) : super([id]);

  @override
  String toString() => 'DeleteShortenEvent{id: $id}';
}

class ToggleFavShortenEvent extends ShortenEvent {
  final String id;

  ToggleFavShortenEvent({this.id}) : super([id]);

  @override
  String toString() => 'ToggleFavShortenEvent{id: $id}';
}

class SyncShortenEvent extends ShortenEvent {
  final String userId;
  final String email;
  final String name;
  final bool silent;

  SyncShortenEvent({this.userId, this.email, this.name, this.silent = false})
      : super([userId, email, name, silent]);

  @override
  String toString() =>
      'SyncShortenEvent{id: $userId, email: $email, name: $name, silent: $silent}';
}
