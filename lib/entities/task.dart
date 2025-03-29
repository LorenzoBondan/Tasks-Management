import 'package:flutter/scheduler.dart';
import 'package:tasks_management/entities/comment.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final Priority priority;
  final bool isCompleted;

  final List<Comment> comments;

  Task({required this.id, required this.title, required this.description, required this.priority, this.isCompleted = false, List<Comment>? comments}) : comments = comments ?? [];
}