// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) {
  return SyncResponse(
    shortens: (json['shortens'] as List) ?? []
        ?.map((e) =>
            e == null ? null : ShortenModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SyncResponseToJson(SyncResponse instance) =>
    <String, dynamic>{
      'shortens': instance.shortens,
    };
