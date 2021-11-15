import 'package:hive/hive.dart';
part 'database.g.dart';

@HiveType(typeId: 0)
class SongDetailsList{
  @HiveField(0)
  final int songId;
  @HiveField(1)
  final String? songName;
  @HiveField(2)
  final String? artistName;
  @HiveField(3)
  final String? artistImage;
  @HiveField(4)
  final  artistType;
  @HiveField(5)
  final int? duration;
  @HiveField(6)
  final String? path;
  @HiveField(7)
  final String? data;

  SongDetailsList(
      {this.songId=0,
      this.songName,
      this.artistName,
      this.artistImage='',
      this.artistType,
      this.duration=0,
      this.path,this.data});





}