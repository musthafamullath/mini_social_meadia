import 'package:hive/hive.dart';

part 'feed_post_model.g.dart'; // This is the generated file for the adapter

@HiveType(typeId: 0)
class FeedPostModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  bool isLiked; 

  @HiveField(4)
  bool isSaved;

  FeedPostModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isLiked = false, 
    this.isSaved = false, 
  });
}
