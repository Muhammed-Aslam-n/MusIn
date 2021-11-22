 import 'package:hive/hive.dart';

part 'database.g.dart';


@HiveType(typeId: 0)
class UserSongs{
  @HiveField(0)
  final String? songName;
  @HiveField(1)
  final String? artistName;
  @HiveField(2)
  final int? duration;
  @HiveField(3)
  final int? imageId;
  @HiveField(4)
  final String? songPath;
  @HiveField(5)
  final bool isFavourited;
  @HiveField(6)
  final bool isAddedtoPlaylist;

  UserSongs(
      {this.songName,
      this.artistName,
      this.duration,
      this.imageId,
      this.songPath,
      this.isAddedtoPlaylist=false,
      this.isFavourited=false});

}


@HiveType(typeId: 1)
class UserPlaylistNames{
  @HiveField(0)
  final String? playlistNames;
  @HiveField(1)
  final int? currespondingKey;

  UserPlaylistNames({this.playlistNames, this.currespondingKey = 0});
}

@HiveType(typeId: 2)
 class UserPlaylistSongs{
  @HiveField(0)
  final int? currespondingPlaylistId;
  @HiveField(1)
  final String? songName;
  @HiveField(2)
  final String? artistName;
  @HiveField(3)
  final String? songPath;
  @HiveField(4)
  final int? songDuration;
  @HiveField(5)
  final int? songImageId;

  UserPlaylistSongs(
      {this.currespondingPlaylistId,
      this.songName,
      this.artistName,
      this.songPath,
      this.songDuration,
      this.songImageId});

}