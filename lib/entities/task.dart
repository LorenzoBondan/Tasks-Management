import 'package:tasks_management/entities/comment.dart';
import 'package:tasks_management/entities/priority.dart';

class Task {
  final int id;
  String title;
  String description;
  Priority priority;
  bool isCompleted;

  final List<Comment> comments;

  Task({required this.id, required this.title, required this.description, required this.priority, this.isCompleted = false, List<Comment>? comments}) : comments = comments ?? [];
}