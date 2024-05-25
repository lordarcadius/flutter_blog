import 'dart:io';

import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/constants.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/feature/blog/presentation/widgets/blog_editor.dart';
import 'package:blog_app/feature/blog/presentation/widgets/text_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  List<String> selectedCategories = [];
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final QuillController _controller = QuillController.basic();
  final formKey = GlobalKey<FormState>();
  File? image;

  @override
  void initState() {
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

  void _publishBlog() {
    if (formKey.currentState!.validate() &&
        selectedCategories.isNotEmpty &&
        image != null) {
      final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
      context.read<BlogBloc>().add(BlogPublish(
            userId: user.id,
            title: titleController.text.trim(),
            content: contentController.text.trim(),
            image: image!,
            topics: selectedCategories,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Blog"),
        actions: [
          IconButton(
            onPressed: () {
              _publishBlog();
            },
            icon: const Icon(
              Icons.done_rounded,
            ),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            showSnackbar(context, "Blog published!");
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _selectImage(),
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image!,
                                height: 250,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                        itemCount: Constants.categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: GestureDetector(
                              onTap: () {
                                final String categoryName =
                                    Constants.categories[index];
                                setState(() {
                                  if (selectedCategories
                                      .contains(categoryName)) {
                                    selectedCategories.remove(categoryName);
                                  } else {
                                    selectedCategories.add(categoryName);
                                  }
                                });
                              },
                              child: Chip(
                                color: selectedCategories
                                        .contains(Constants.categories[index])
                                    ? const WidgetStatePropertyAll(
                                        AppPallete.gradient1)
                                    : null,
                                side: const BorderSide(
                                    color: AppPallete.borderColor),
                                label: Text(
                                  Constants.categories[index],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlogEditor(
                        controller: titleController, hintText: "Blog Title"),
                    const SizedBox(height: 20),
                    TextEditor(controller: _controller),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
