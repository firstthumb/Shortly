import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';

part 'shorten_model.g.dart';

const String shortenModelHiveName = "ShortenModelHive";

@HiveType()
class ShortenModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String link;

  @HiveField(2)
  final String shortLink;

  @HiveField(3)
  final bool fav;

  ShortenModel({
    this.id,
    @required this.link,
    @required this.shortLink,
    @required this.fav
  }) : super([id, link, shortLink, fav]);

  Shorten toEntity() {
    return Shorten(id: id, link: link, shortLink: shortLink, fav: fav);
  }

  static ShortenModel fromEntity(Shorten entity) {
    return ShortenModel(id: entity.id,
        link: entity.link,
        shortLink: entity.shortLink,
        fav: entity.fav);
  }

  static ShortenModel fromJson(Map<String, dynamic> json) {
    return ShortenModel(
      link: json['url'],
      shortLink: json['short_url'],
      fav: false,
    );
  }

  @override
  String toString() {
    return 'ShortenModel{id: $id, link: $link, shortLink: $shortLink, fav: $fav}';
  }
}
