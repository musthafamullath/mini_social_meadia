// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mechine_task_cumin360/models/feed_post_model.dart';
import 'package:mechine_task_cumin360/sources/constants/colors.dart';
import 'package:mechine_task_cumin360/views/feed_tab/widgets/feeds_adding_to_home.dart';

class FeedTabView extends StatefulWidget {
  const FeedTabView({super.key});

  @override
  FeedTabViewState createState() => FeedTabViewState();
}

class FeedTabViewState extends State<FeedTabView> {
  late Box<FeedPostModel> _feedPostBox;
  bool _isBoxOpened = false; 

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _feedPostBox = await Hive.openBox<FeedPostModel>('feedPosts');
    setState(() {
      _isBoxOpened = true; // Mark as initialized
    });
  }

  void _toggleLike(int index) {
    setState(() {
      final post = _feedPostBox.getAt(index)!;
      post.isLiked = !post.isLiked;
      _feedPostBox.putAt(index, post);
    });
  }

  void _toggleSave(int index) {
    setState(() {
      final post = _feedPostBox.getAt(index)!;
      post.isSaved = !post.isSaved;
      _feedPostBox.putAt(index, post);
    });
  }

  void _addNewFeed() async {
    try {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FeedsAddingToHome()),
      );
      
    } catch (e) {
      print("Error navigating to FeedsAddingToHome: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Feeds',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        backgroundColor: yellow,
        actions: <Widget>[
          Container(
            height: 35,
            width: 140,
            margin: const EdgeInsets.only(right: 10, bottom: 7.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: white),
            child: TextButton.icon(
              onPressed: _addNewFeed,
              label: const Text(
                "Add New Feeds",
                style: TextStyle(
                  color: grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: grey,
                size: 18,
              ),
            ),
          )
        ],
      ),
      body: _isBoxOpened
          ? ValueListenableBuilder(
              valueListenable: _feedPostBox.listenable(),
              builder: (context, Box<FeedPostModel> box, _) {
                final posts = box.values.toList();
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: post.imageUrl.isNotEmpty
                                ? (post.imageUrl.startsWith('http')
                                    ? Image.network(post.imageUrl,
                                        width: double.infinity, height: 300)
                                    : (File(post.imageUrl).existsSync()
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image.file(
                                              File(post.imageUrl),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 300,
                                            ),
                                          )
                                        : Container(
                                            width: double.infinity,
                                            height: 300,
                                            color: Colors.grey,
                                            child: const Center(
                                              child: Text('Image not found'),
                                            ),
                                          )))
                                : Container(
                                    width: double.infinity,
                                    height: 300,
                                    color: Colors.grey,
                                    child: const Center(
                                      child: Text('No image available'),
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              post.description,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  post.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      post.isLiked ? Colors.red : null,
                                ),
                                onPressed: () => _toggleLike(index),
                              ),
                              IconButton(
                                icon: Icon(
                                  post.isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color:
                                      post.isSaved ? Colors.blue : null,
                                ),
                                onPressed: () => _toggleSave(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()), // Show loading indicator while box is opening
    );
  }
}
