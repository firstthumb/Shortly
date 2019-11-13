// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncRequest _$SyncRequestFromJson(Map<String, dynamic> json) {
  return SyncRequest(
    shortens: (json['shortens'] as List)
        ?.map((e) =>
            e == null ? null : ShortenModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    deleted: (json['deleted'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$SyncRequestToJson(SyncRequest instance) =>
    <String, dynamic>{
      'shortens': instance.shortens,
      'deleted': instance.deleted,
    };
