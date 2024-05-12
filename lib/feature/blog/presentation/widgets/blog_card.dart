import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/helper.dart';
import 'package:blog_app/feature/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/feature/blog/domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({
    Key? key,
    required this.blog,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 200,
        margin: const EdgeInsets.all(16).copyWith(bottom: 0),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: blog.topics.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Chip(
                      side: const BorderSide(color: AppPallete.borderColor),
                      label: Text(
                        blog.topics[index],
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(
              blog.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text("${Helper.calculateReadingTime(blog.content)} mins"),
          ],
        ),
      ),
    );
  }
}
