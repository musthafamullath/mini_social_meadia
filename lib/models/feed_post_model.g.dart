// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedPostModelAdapter extends TypeAdapter<FeedPostModel> {
  @override
  final int typeId = 0;

  @override
  FeedPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedPostModel(
      title: fields[0] as String,
      description: fields[1] as String,
      imageUrl: fields[2] as String,
      isLiked: fields[3] as bool,
      isSaved: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FeedPostModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.isLiked)
      ..writeByte(4)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
