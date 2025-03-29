import 'package:flutter/material.dart';
import 'package:tasks_management/entities/comment.dart';
import 'package:tasks_management/repositories/comment_repository.dart';

class CommentService extends ChangeNotifier {
  final CommentRepository repository = CommentRepository();

  List<Comment> get findAll => repository.findAll; 

  List<Comment> findByTaskId(int taskId) {
    return repository.findByTaskId(taskId);
  }

  Comment? findById(int id) {
    return repository.findById(id);
  }

  void create(Comment obj) {
    repository.create(obj);
    notifyListeners();
  }

  void update(Comment obj) {
    repository.update(obj);
    notifyListeners();
  }

  void delete(int id) {
    repository.delete(id);
    notifyListeners();
  }
}