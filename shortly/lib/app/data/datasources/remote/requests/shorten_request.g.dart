// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shorten_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortenRequest _$ShortenRequestFromJson(Map<String, dynamic> json) {
  return ShortenRequest(
    link: json['link'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$ShortenRequestToJson(ShortenRequest instance) =>
    <String, dynamic>{
      'link': instance.link,
      'type': instance.type,
    };
