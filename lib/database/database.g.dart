// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSongsAdapter extends TypeAdapter<UserSongs> {
  @override
  final int typeId = 0;

  @override
  UserSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSongs(
      songName: fields[0] as String?,
      artistName: fields[1] as String?,
      duration: fields[2] as int?,
      imageId: fields[3] as int?,
      songPath: fields[4] as String?,
      isAddedtoPlaylist: fields[6] as bool,
      isFavourited: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserSongs obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.songName)
      ..writeByte(1)
      ..write(obj.artistName)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.imageId)
      ..writeByte(4)
      ..write(obj.songPath)
      ..writeByte(5)
      ..write(obj.isFavourited)
      ..writeByte(6)
      ..write(obj.isAddedtoPlaylist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserPlaylistNamesAdapter extends TypeAdapter<UserPlaylistNames> {
  @override
  final int typeId = 1;

  @override
  UserPlaylistNames read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPlaylistNames(
      playlistNames: fields[0] as String?,
      currespondingKey: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserPlaylistNames obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlistNames)
      ..writeByte(1)
      ..write(obj.currespondingKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPlaylistNamesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserPlaylistSongsAdapter extends TypeAdapter<UserPlaylistSongs> {
  @override
  final int typeId = 2;

  @override
  UserPlaylistSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPlaylistSongs(
      currespondingPlaylistId: fields[0] as int?,
      songName: fields[1] as String?,
      artistName: fields[2] as String?,
      songPath: fields[3] as String?,
      songDuration: fields[4] as int?,
      songImageId: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserPlaylistSongs obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.currespondingPlaylistId)
      ..writeByte(1)
      ..write(obj.songName)
      ..writeByte(2)
      ..write(obj.artistName)
      ..writeByte(3)
      ..write(obj.songPath)
      ..writeByte(4)
      ..write(obj.songDuration)
      ..writeByte(5)
      ..write(obj.songImageId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPlaylistSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
