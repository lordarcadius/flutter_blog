import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class TextEditor extends StatefulWidget {
  final QuillController controller;
  const TextEditor({super.key, required this.controller});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillToolbar.simple(
          configurations: QuillSimpleToolbarConfigurations(
            controller: widget.controller,
            sharedConfigurations: const QuillSharedConfigurations(
              locale: Locale('en'),
            ),
          ),
        ),
        QuillEditor.basic(
          configurations: QuillEditorConfigurations(
            controller: widget.controller,
          
            sharedConfigurations: const QuillSharedConfigurations(
              locale: Locale('en'),
            ),
          ),
        )
      ],
    );
  }
}
