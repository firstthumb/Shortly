import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Shorten extends Equatable {
  final String id;
  final String link;
  final String shortLink;
  final bool fav;

  Shorten({
    this.id,
    @required this.link,
    @required this.shortLink,
    @required this.fav,
  }) : super([id, link, shortLink, fav]);

  @override
  String toString() {
    return "Shorten{id: $id, link: $link, shortLink: $shortLink, fav: $fav}";
  }
}
