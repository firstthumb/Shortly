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
    );
  }

  @override
  void write(BinaryWriter writer, ShortenModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.link)
      ..writeByte(2)
      ..write(obj.shortLink)
      ..writeByte(3)
      ..write(obj.fav);
  }
}
