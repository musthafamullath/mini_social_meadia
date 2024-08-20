import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:mechine_task_cumin360/sources/constants/colors.dart';
import 'package:mechine_task_cumin360/widgets/text_field_widget.dart';
import 'package:mechine_task_cumin360/models/feed_post_model.dart';

class FeedsAddingToHome extends StatefulWidget {
  const FeedsAddingToHome({
    super.key,
    required this.titles,
    required this.decorations,
    required this.imageUrls,
    required this.index,
  });

  final String titles;
  final String decorations;
  final String imageUrls;
  final int index;

  @override
  State<FeedsAddingToHome> createState() => _FeedsAddingToHomeState();
}

class _FeedsAddingToHomeState extends State<FeedsAddingToHome> {
  final TextEditingController _titles = TextEditingController();
  final TextEditingController _descriptions = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titles.text = widget.titles;
    _descriptions.text = widget.decorations;
    _imageUrlController.text = widget.imageUrls;
    _imagePath = widget.imageUrls;
  }

  @override
  void dispose() {
    _titles.dispose();
    _descriptions.dispose();
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

  void _addNewPost() async {
    final box = Hive.box<FeedPostModel>('feedPosts');

    final newPost = FeedPostModel(
      title: _titles.text,
      description: _descriptions.text,
      imageUrl: _imagePath ?? '',
    );

    await box.add(newPost);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellow,
        title: const Text('Add New Feed'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                        : Image.network(
                            'https://via.placeholder.com/150'),
                  ),
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  userController: _titles,
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
                const SizedBox(height: 20),
                TextFieldWidget(
                  userController: _descriptions,
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
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _addNewPost,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(yellow),
                  ),
                  child: const Text(
                    'Add New Feed',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
