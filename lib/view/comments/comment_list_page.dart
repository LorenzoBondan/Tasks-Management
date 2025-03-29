import 'package:flutter/material.dart';
import 'package:tasks_management/entities/comment.dart';
import 'package:tasks_management/utils/formatters.dart';

class CommentListPage extends StatelessWidget {
  final List<Comment> comments;

  const CommentListPage({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return ListTile(
            title: Text(comment.text, style: const TextStyle(fontSize: 14)),
            subtitle: Text(formatDate(comment.moment), style: const TextStyle(fontSize: 12)),
          );
        },
      ),
    );
  }
}
