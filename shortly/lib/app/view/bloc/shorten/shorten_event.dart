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

class AddShortenEvent extends ShortenEvent {
  final String link;
  final String shortLink;

  AddShortenEvent({this.link, this.shortLink}) : super([link, shortLink]);

  @override
  String toString() => "AddShortenEvent{ link: $link, shortLink: $shortLink}";
}
