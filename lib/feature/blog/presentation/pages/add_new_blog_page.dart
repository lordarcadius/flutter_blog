import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/feature/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  late List<String> categories;
  List<String> selectedCategories = [];
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  File? image;

  @override
  void initState() {
    categories = ["Business", "Technology", "Programming", "Entertainment"];
    super.initState();
  }

  void _selectImage() async {
    final selectedImage = await pickImage();
    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Blog"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.done_rounded,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _selectImage(),
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          image!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : DottedBorder(
                        color: AppPallete.borderColor,
                        dashPattern: const [10, 4],
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        child: const SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.folder_open_outlined,
                                size: 40,
                              ),
                              Text(
                                "Select your image",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          final String categoryName = categories[index];
                          setState(() {
                            if (selectedCategories.contains(categoryName)) {
                              selectedCategories.remove(categoryName);
                            } else {
                              selectedCategories.add(categoryName);
                            }
                          });
                        },
                        child: Chip(
                          color: selectedCategories.contains(categories[index])
                              ? const MaterialStatePropertyAll(
                                  AppPallete.gradient1)
                              : null,
                          side: const BorderSide(color: AppPallete.borderColor),
                          label: Text(
                            categories[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              BlogEditor(controller: titleController, hintText: "Blog Title"),
              const SizedBox(height: 20),
              BlogEditor(
                  controller: contentController, hintText: "Blog Content"),
            ],
          ),
        ),
      ),
    );
  }
}
