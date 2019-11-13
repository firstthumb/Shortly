import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'shorten_response.g.dart';

@JsonSerializable()
class ShortenResponse extends Equatable {
  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'short_url')
  final String shortUrl;

  ShortenResponse({
    @required this.url,
    @required this.shortUrl,
  }) : super([url, shortUrl]);

  factory ShortenResponse.fromJson(Map<String, dynamic> json) =>
      _$ShortenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShortenResponseToJson(this);
}
