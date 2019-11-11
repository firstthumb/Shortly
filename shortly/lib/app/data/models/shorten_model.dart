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

  @HiveField(4)
  final DateTime createdAt;

  ShortenModel({
    this.id,
    @required this.link,
    @required this.shortLink,
    @required this.fav,
    @required this.createdAt,
  }) : super([id, link, shortLink, fav]);

  Shorten toEntity() {
    return Shorten(id: id,
        link: link,
        shortLink: shortLink,
        fav: fav,
        createdAt: createdAt);
  }

  static ShortenModel fromEntity(Shorten entity) {
    return ShortenModel(
      id: entity.id,
      link: entity.link,
      shortLink: entity.shortLink,
      fav: entity.fav,
      createdAt: DateTime.now(),
    );
  }

  factory ShortenModel.fromJson(Map<String, dynamic> json) {
    return ShortenModel(
      id: json['id'],
      link: json['url'],
      shortLink: json['short_url'],
      fav: false,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'link': link,
        'short_link': shortLink,
        'fav': fav,
        'created_at': createdAt,
      };

  @override
  String toString() {
    return 'ShortenModel{id: $id, link: $link, shortLink: $shortLink, fav: $fav, createdAt: $createdAt}';
  }
}
