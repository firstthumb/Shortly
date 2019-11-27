import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/data/models/shorten_model.dart';

part 'sync_request.g.dart';

@JsonSerializable()
class SyncRequest extends Equatable {
  @JsonKey(name: 'shortens')
  final List<ShortenModel> shortens;

  @JsonKey(name: 'deleted')
  final List<String> deleted;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'name')
  final String name;

  SyncRequest({
    @required this.shortens,
    @required this.deleted,
    @required this.email,
    @required this.name,
  }) : super([shortens, deleted, email, name]);

  factory SyncRequest.fromJson(Map<String, dynamic> json) =>
      _$SyncRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SyncRequestToJson(this);
}
