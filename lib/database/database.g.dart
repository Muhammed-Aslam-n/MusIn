// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongDetailsListAdapter extends TypeAdapter<SongDetailsList> {
  @override
  final int typeId = 0;

  @override
  SongDetailsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongDetailsList(
      songId: fields[0] as int,
      songName: fields[1] as String?,
      artistName: fields[2] as String?,
      artistImage: fields[3] as String?,
      artistType: fields[4] as dynamic,
      duration: fields[5] as int?,
      path: fields[6] as String?,
      data: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SongDetailsList obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.songId)
      ..writeByte(1)
      ..write(obj.songName)
      ..writeByte(2)
      ..write(obj.artistName)
      ..writeByte(3)
      ..write(obj.artistImage)
      ..writeByte(4)
      ..write(obj.artistType)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.path)
      ..writeByte(7)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongDetailsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
