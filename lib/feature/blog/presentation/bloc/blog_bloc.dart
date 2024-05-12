import 'dart:io';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/blog/domain/entities/blog.dart';
import 'package:blog_app/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogPublish>(_onBlogPublish);
    on<BlogFetchAllBlogs>(_onBlogFetchAllBlogs);
  }

  void _onBlogPublish(BlogPublish event, Emitter<BlogState> emit) async {
    final result = await _uploadBlog(UploadBlogParams(
      userId: event.userId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));

    result.fold(
      (l) => emit(BlogFailure(error: l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onBlogFetchAllBlogs(
      BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final result = await _getAllBlogs(NoParams());

    result.fold(
      (l) => emit(BlogFailure(error: l.message)),
      (r) => emit(BlogFetchSuccess(blogs: r)),
    );
  }
}
