// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shorten_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShortenModelAdapter extends TypeAdapter<ShortenModel> {
  @override
  ShortenModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShortenModel(
      id: fields[0] as String,
      link: fields[1] as String,
      shortLink: fields[2] as String,
      fav: fields[3] as bool,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ShortenModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.link)
      ..writeByte(2)
      ..write(obj.shortLink)
      ..writeByte(3)
      ..write(obj.fav)
      ..writeByte(4)
      ..write(obj.createdAt);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortenModel _$ShortenModelFromJson(Map<String, dynamic> json) {
  return ShortenModel(
    id: json['id'] as String,
    link: json['link'] as String,
    shortLink: json['short_link'] as String,
    fav: json['fav'] as bool,
    createdAt: ShortenModel._dateTimeFromEpoch(json['created_at'] as int),
  );
}

Map<String, dynamic> _$ShortenModelToJson(ShortenModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'link': instance.link,
      'short_link': instance.shortLink,
      'fav': instance.fav,
      'created_at': ShortenModel._dateTimeToEpoch(instance.createdAt),
    };
