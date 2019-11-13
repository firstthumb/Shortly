// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shorten_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortenResponse _$ShortenResponseFromJson(Map<String, dynamic> json) {
  return ShortenResponse(
    url: json['url'] as String,
    shortUrl: json['short_url'] as String,
  );
}

Map<String, dynamic> _$ShortenResponseToJson(ShortenResponse instance) =>
    <String, dynamic>{
      'url': instance.url,
      'short_url': instance.shortUrl,
    };
