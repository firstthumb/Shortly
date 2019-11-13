import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';

part 'shorten_model.g.dart';

const String shortenModelHiveName = "ShortenModelHive";

@JsonSerializable()
@HiveType()
class ShortenModel extends Equatable {
  @JsonKey(name: 'id')
  @HiveField(0)
  final String id;

  @JsonKey(name: 'link')
  @HiveField(1)
  final String link;

  @JsonKey(name: 'short_link')
  @HiveField(2)
  final String shortLink;

  @JsonKey(name: 'fav')
  @HiveField(3)
  final bool fav;

  @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromEpoch,
      toJson: _dateTimeToEpoch)
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
    return Shorten(
        id: id,
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

  factory ShortenModel.fromJson(Map<String, dynamic> json) =>
      _$ShortenModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShortenModelToJson(this);

  static DateTime _dateTimeFromEpoch(int us) =>
      us == null ? null : DateTime.fromMillisecondsSinceEpoch(us, isUtc: true);

  static int _dateTimeToEpoch(DateTime dateTime) =>
      dateTime
          ?.toUtc()
          ?.millisecondsSinceEpoch;

  @override
  String toString() {
    return 'ShortenModel{id: $id, link: $link, shortLink: $shortLink, fav: $fav, createdAt: $createdAt}';
  }
}
