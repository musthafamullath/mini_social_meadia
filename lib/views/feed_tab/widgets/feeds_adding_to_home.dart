// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:mechine_task_cumin360/sources/constants/colors.dart';
import 'package:mechine_task_cumin360/sources/constants/widgets.dart';
import 'package:mechine_task_cumin360/widgets/button_widget.dart';
import 'package:mechine_task_cumin360/widgets/text_field_widget.dart';
import 'package:mechine_task_cumin360/models/feed_post_model.dart';

class FeedsAddingToHome extends StatefulWidget {
  const FeedsAddingToHome({
    super.key,
    this.titles,
    this.decorations,
    this.imageUrls,
    this.index,
  });

  final String? titles;
  final String? decorations;
  final String? imageUrls;
  final int? index;

  @override
  State<FeedsAddingToHome> createState() => _FeedsAddingToHomeState();
}

class _FeedsAddingToHomeState extends State<FeedsAddingToHome> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.titles ?? '';
    _descriptionController.text = widget.decorations ?? '';
    _imageUrlController.text = widget.imageUrls ?? '';
    _imagePath = widget.imageUrls;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _imageUrlController.text = _imagePath!;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _saveFeed() async {
    if (_formKey.currentState!.validate()) {
      try {
        final box = await Hive.openBox<FeedPostModel>('feedPosts');
        final newFeed = FeedPostModel(
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: _imagePath ?? '',
          isLiked: false,
          isSaved: false,
        );
        await box.add(newFeed);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feed added successfully')),
        );

        Navigator.of(context).pop();
      } catch (e) {
        print("Error saving feed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error adding feed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellow,
        title: const Text('Add New Feed'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                        image: _imagePath != null
                            ? DecorationImage(
                                image: FileImage(
                                  File(_imagePath!),
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _imagePath != null
                          ? Image.file(File(_imagePath!))
                          : const Icon(
                              Mdi.image,
                              size: 50,
                              color: grey,
                            ),
                    ),
                  ),
                  kHight20,
                  TextFieldWidget(
                    userController: _titleController,
                    label: 'Title',
                    inputType: TextInputType.name,
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a title";
                      }
                      return null;
                    },
                  ),
                  kHight20,
                  TextFieldWidget(
                    userController: _descriptionController,
                    label: 'Description',
                    inputType: TextInputType.name,
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a Description";
                      }
                      return null;
                    },
                  ),
                  kHight30,
                  ButtonWidget(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height *1/10,
                    text: 'Add Feed',
                    onPressed: _saveFeed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
