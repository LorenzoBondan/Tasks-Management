import 'package:flutter/material.dart';
import 'package:tasks_management/entities/comment.dart';
import 'package:tasks_management/utils/formatters.dart';
import 'package:tasks_management/view/comments/comment_form_page.dart';

class CommentListPage extends StatelessWidget {
  final List<Comment> comments;
  final Function(int) onDelete;

  const CommentListPage({super.key, required this.comments, required this.onDelete});

  void _confirmDelete(BuildContext context, int commentId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this comment?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onDelete(commentId);
                Navigator.pop(dialogContext);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentFormPage(comment: comment, taskId: comment.taskId)),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, comment.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
