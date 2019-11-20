import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/data/models/shorten_model.dart';

part 'sync_response.g.dart';

@JsonSerializable()
class SyncResponse extends Equatable {
  @JsonKey(name: 'shortens', nullable: true)
  final List<ShortenModel> shortens;

  SyncResponse({
    @required this.shortens,
  }) : super([shortens]);

  factory SyncResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SyncResponseToJson(this);
}
