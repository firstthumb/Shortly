import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'shorten_request.g.dart';

@JsonSerializable()
class ShortenRequest extends Equatable {
  @JsonKey(name: 'link')
  final String link;

  ShortenRequest({
    @required this.link,
  }) : super([link]);

  factory ShortenRequest.fromJson(Map<String, dynamic> json) =>
      _$ShortenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ShortenRequestToJson(this);
}
